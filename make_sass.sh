for name in "$@"; do
    sassc css/$name.sass css/$name.css
done
