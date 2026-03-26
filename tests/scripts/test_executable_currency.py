import importlib.machinery
import importlib.util
import io
import pathlib
import unittest
from contextlib import redirect_stderr, redirect_stdout
from unittest.mock import patch


SCRIPT_PATH = pathlib.Path(__file__).resolve().parents[2] / "scripts" / "executable_currency"


def load_currency_module():
    loader = importlib.machinery.SourceFileLoader("executable_currency", str(SCRIPT_PATH))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


class CurrencyScriptTest(unittest.TestCase):
    def test_main_converts_using_open_exchange_rate_provider(self):
        module = load_currency_module()

        stdout = io.StringIO()
        stderr = io.StringIO()

        response = unittest.mock.Mock()
        response.status_code = 200
        response.json.return_value = {
            "result": "success",
            "rates": {"CAD": 1.35},
        }

        with patch.object(module.requests, "get", return_value=response) as mock_get:
            with patch.object(module.sys, "argv", ["currency", "USD", "CAD", "2"]):
                with redirect_stdout(stdout), redirect_stderr(stderr):
                    exit_code = module.main()

        self.assertEqual(exit_code, 0)
        self.assertEqual(stderr.getvalue(), "")
        self.assertEqual(stdout.getvalue().strip(), "2.0 USD = 2.7 CAD")
        mock_get.assert_called_once_with(
            "https://open.er-api.com/v6/latest/USD",
            timeout=module.REQUEST_TIMEOUT_SECONDS,
        )

    def test_main_returns_generic_error_on_connection_failure(self):
        module = load_currency_module()

        stdout = io.StringIO()
        stderr = io.StringIO()

        with patch.object(
            module.requests,
            "get",
            side_effect=module.requests.ConnectionError("dns exploded"),
        ):
            with patch.object(module.sys, "argv", ["currency", "USD", "CAD", "1"]):
                with redirect_stdout(stdout), redirect_stderr(stderr):
                    exit_code = module.main()

        self.assertEqual(exit_code, 1)
        self.assertEqual(stdout.getvalue(), "")
        self.assertEqual(
            stderr.getvalue().strip(),
            "Error: Unable to fetch exchange rates. Check your network and try again.",
        )

    def test_main_returns_error_on_request_timeout(self):
        module = load_currency_module()

        stdout = io.StringIO()
        stderr = io.StringIO()

        with patch.object(module.requests, "get", side_effect=module.requests.Timeout("timed out")) as mock_get:
            with patch.object(module.sys, "argv", ["currency", "USD", "CAD", "1"]):
                with redirect_stdout(stdout), redirect_stderr(stderr):
                    exit_code = module.main()

        self.assertEqual(exit_code, 1)
        self.assertEqual(stdout.getvalue(), "")
        self.assertIn("timed out", stderr.getvalue().lower())
        mock_get.assert_called_once_with(
            "https://open.er-api.com/v6/latest/USD",
            timeout=module.REQUEST_TIMEOUT_SECONDS,
        )
