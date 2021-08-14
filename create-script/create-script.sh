#!/bin/sh

fail() {
    echo "Fatal error: $1"
    exit 1
}

NAME=$1

if [ -z "$NAME" ]; then
    echo "Usage: create-script [name]"
    exit 1;
fi

[ -f "$HOME/.scripts/bin/$NAME" ] && fail "script already exists"

echo "Creating script folder"
cd "$HOME/.scripts" || exit 1
mkdir "$NAME" || exit 1

echo "Creating README.md"
echo "\
# $NAME

## About
-- about section here --

## Requirements
-- any requirements --"\
> "$NAME/README.md" || exit 1

echo "Creating $NAME.sh"
echo "\
#!/bin/sh"\
> "$NAME/$NAME.sh" || exit 1

echo "Linking $NAME.sh to bin folder"
chmod +x "$NAME/$NAME.sh" || exit 1
ln -s -r "$NAME/$NAME.sh" "bin/$NAME" || exit 1

echo "Done"
