for name in "$@"; do
    cp css/$name.css dist
    cp css/$name.min.css dist
done
