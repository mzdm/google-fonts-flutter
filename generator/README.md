### Generating language files
To generate the `GoogleFonts` class and its language classes:

1. Navigate to the root directory of this project.
2. run: `$ dart generator/generator.dart`
</br>

### Running with an argument
  - `--fetch-langs` argument then each font is checked via Google Fonts API
and written to fonts.json, if any a language of the font was not possible
to recognize then that font is writte to `errors.json`,
  - `--try-handle-errors` argument then each font from errors.json is
tried to be fetched from a different API.

Note: Running with arguments will not generate the final .dart base & language files.
