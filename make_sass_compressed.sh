for name in "$@"; do
    sassc --style compressed css/$name.sass css/$name.css
done
