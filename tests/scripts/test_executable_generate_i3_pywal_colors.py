import importlib.machinery
import importlib.util
import json
import pathlib
import tempfile
import unittest


SCRIPT_PATH = (
    pathlib.Path(__file__).resolve().parents[2]
    / "scripts"
    / "executable_generate-i3-pywal-colors"
)


def load_module():
    loader = importlib.machinery.SourceFileLoader(
        "executable_generate_i3_pywal_colors", str(SCRIPT_PATH)
    )
    spec = importlib.util.spec_from_loader(loader.name, loader)
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


class GenerateI3PywalColorsTest(unittest.TestCase):
    def test_main_writes_contrast_safe_i3_resources(self):
        module = load_module()

        with tempfile.TemporaryDirectory() as tmpdir:
            tmpdir_path = pathlib.Path(tmpdir)
            input_path = tmpdir_path / "colors.json"
            output_path = tmpdir_path / "colors-i3.Xresources"

            input_path.write_text(
                json.dumps(
                    {
                        "special": {
                            "background": "#121217",
                            "foreground": "#a2c0c6",
                            "cursor": "#a2c0c6",
                        },
                        "colors": {
                            "color0": "#121217",
                            "color1": "#E5A055",
                            "color2": "#EBD861",
                            "color3": "#492B96",
                            "color4": "#34548D",
                            "color5": "#4B6895",
                            "color6": "#BC40AB",
                            "color7": "#a2c0c6",
                            "color8": "#71868a",
                            "color9": "#E5A055",
                            "color10": "#EBD861",
                            "color11": "#492B96",
                            "color12": "#34548D",
                            "color13": "#4B6895",
                            "color14": "#BC40AB",
                            "color15": "#a2c0c6",
                        },
                    }
                ),
                encoding="utf-8",
            )

            exit_code = module.main(
                ["--input", str(input_path), "--output", str(output_path)]
            )

            self.assertEqual(exit_code, 0)
            resource_map = self.parse_resource_file(output_path)

            for key in (
                "i3wm.ui.text",
                "i3wm.ui.focus_bg",
                "i3wm.ui.focus_text",
                "i3wm.ui.active_bg",
                "i3wm.ui.active_text",
                "i3wm.ui.inactive_bg",
                "i3wm.ui.inactive_text",
            ):
                self.assertIn(key, resource_map)

            self.assertGreaterEqual(
                module.contrast_ratio(
                    resource_map["i3wm.ui.focus_bg"],
                    resource_map["i3wm.ui.focus_text"],
                ),
                module.MIN_CONTRAST_RATIO,
            )
            self.assertGreaterEqual(
                module.contrast_ratio(
                    resource_map["i3wm.ui.active_bg"],
                    resource_map["i3wm.ui.active_text"],
                ),
                module.MIN_CONTRAST_RATIO,
            )
            self.assertGreaterEqual(
                module.contrast_ratio(
                    resource_map["i3wm.ui.inactive_bg"],
                    resource_map["i3wm.ui.inactive_text"],
                ),
                module.MIN_CONTRAST_RATIO,
            )

    @staticmethod
    def parse_resource_file(path):
        resources = {}
        for line in path.read_text(encoding="utf-8").splitlines():
            stripped = line.strip()
            if not stripped or stripped.startswith("!"):
                continue
            key, value = stripped.split(":", 1)
            resources[key.strip()] = value.strip()
        return resources


if __name__ == "__main__":
    unittest.main()
