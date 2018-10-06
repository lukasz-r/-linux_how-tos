
# file encryption / keys (GnuPG)

+ `gpg2` is preferred over `gpg`

+ the keys are stored in `~/.gnupg`

+ encrypt a file: `gpg2 -c file`

+ decrypt a file: `gpg2 file.gpg2`

+ create a gpg2 key: `gpg2 --gen-key`

+ list gpg2 keys (with their key_id's): `gpg2 --list-keys`

+ send a gpg2 key to a server: `gpg2 --send-key key_id`

+ look for a gpg2 key by user email: `gpg2 --search-key user@server`

+ sign a gpg2 key of a user: `gpg2 --sign-key key_id`

+ export a public key to a file: `gpg2 -ao user-pub.asc --export key_id`

+ export a private key to a file: `gpg2 -ao user-priv.asc --export-secret-keys key_id`
