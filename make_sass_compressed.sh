for name in "$@"; do
    sassc --style compressed css/$name.sass css/$name.min.css
done
