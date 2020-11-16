This directory contains manually added mapped fonts.


Cause: Supported languages of these fonts were not successfully retrieved from the Google Fonts API call response (see more in generator/generator_helper.dart).
Usually it happens with Korean, Chinese and Japanese fonts. A better way of automating this is in works.


Because all of these fonts are already handled here they will not occur again in errors.txt (when fetching from the API).