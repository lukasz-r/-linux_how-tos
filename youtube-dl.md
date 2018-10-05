
# youtube-dl

+ get a list of video titles in a playlist:

	```bash
	youtube-dl -j --flat-playlist 'https://www.youtube.com/watch?v=fiHRBD17HLU&index=1&list=PLsRo8FEJKxV9F1AJvkj0jgK6IAt2QRBMA' | jq ".title"
	```
