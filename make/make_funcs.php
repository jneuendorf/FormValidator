<?php

function readfile_indent($filename, $indentation=4) {
    $contents = file_get_contents($filename);
    $lines = explode("\n", $contents);
    foreach ($lines as $i => $line) {
        // skip indentation for 1st line because the php code is already indented
        if ($i > 0 && !empty($line)) {
            $lines[$i] = str_repeat(' ', $indentation).$line;
        }
    }
    echo implode("\n", $lines);
}
