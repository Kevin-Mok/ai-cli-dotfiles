function fn-progress
    # --- Season Dates (Fortnite Chapter 7 Season 2) ---
    set SEASON_START "2026-03-19 00:00:00"
    set SEASON_END "2026-06-05 00:00:00"

    # --- Calculate Unix Timestamps ---
    set START_SECONDS (date -d "$SEASON_START" +%s)
    set END_SECONDS (date -d "$SEASON_END" +%s)
    set CURRENT_SECONDS (date +%s)
    set CURRENT_DATE_TIME (date)

    # --- Check if the season is over or hasn't started ---
    if test "$CURRENT_SECONDS" -lt "$START_SECONDS"
        echo "🎯 Fortnite C7S2 hasn't started yet! (Starts on $SEASON_START)"
        return
    end

    if test "$CURRENT_SECONDS" -ge "$END_SECONDS"
        echo "🎉 Fortnite C7S2 has ended! (Ended on $SEASON_END)"
        return
    end

    # --- Calculate Progress ---
    set TOTAL_DURATION (math "$END_SECONDS - $START_SECONDS")
    set TIME_PASSED (math "$CURRENT_SECONDS - $START_SECONDS")

    # --- Calculate the ceiling percentage (The Critical Change) ---
    # Setting scale=0 forces bc to output only the integer part (truncation), 
    # and adding 0.9999 before truncation implements the ceiling logic.
    set PROGRESS_PERCENT (echo "scale=0; (($TIME_PASSED * 100) / $TOTAL_DURATION) + 0.9999" | bc)

    # --- Output Result ---
    echo "📅 Current Date/Time: $CURRENT_DATE_TIME"
    echo "🚀 Season Start: $SEASON_START"
    echo "🛑 Season End: $SEASON_END"
    echo "---"
    echo "✅ Fortnite C7S2 is **$PROGRESS_PERCENT%** complete!"
    echo "---"
end
