These files are auto-generated. Please do not edit.

This directory contains fonts & error handled fonts that are concatenated after fetching together.

**The cause of unrecognized/error fonts:**
 - The supported languages of these fonts were not successfully retrieved from the Google Fonts API call response (see more in generator/generator_helper.dart). Usually, it happens with Korean, Chinese, and Japanese fonts.
</br>

All fonts that are in error_handled_fonts.json file are already handled so they will not occur in errors.json again (when fetching from the Google Fonts API with the `--fetch-langs` argument).
 - To try handling fonts in error.json use an argument `--try-handle-fonts` (these are fetched from a different API than Google Fonts)