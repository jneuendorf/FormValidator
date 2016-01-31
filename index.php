<?php

$tabs = ['features', 'demos', 'usage', 'settings'];

?>
<!DOCTYPE html>
<html lang="en-us">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Formvalidator by jneuendorf</title>

    <link rel="stylesheet" type="text/css" href="stylesheets/normalize.css" media="screen">
    <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" type="text/css" href="stylesheets/stylesheet.css" media="screen">
    <link rel="stylesheet" type="text/css" href="stylesheets/github-light.css" media="screen">
    <link rel="stylesheet" type="text/css" href="stylesheets/my-bootstrap.css" media="screen">

    <link rel="stylesheet" type="text/css" href="stylesheets/shCore.css" media="screen">
    <link rel="stylesheet" type="text/css" href="stylesheets/shThemeDefault.css" media="screen">

    <link rel="stylesheet" type="text/css" href="stylesheets/my-style.css" media="screen">

    <script type="text/javascript" src="js/jquery-2.2.0.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <script type="text/javascript" src="js/shCore.js"></script>
    <script type="text/javascript" src="js/brushes/shBrushJScript.js"></script>
    <script type="text/javascript" src="js/brushes/shBrushXml.js"></script>

    <script type="text/javascript" src="js/FormValidator.js"></script>
</head>

<body>
    <section class="page-header">
        <h1 class="project-name">FormValidator</h1>
        <h2 class="project-tagline">A smart, easy-to-use, and fast JavaScript form validator.</h2>
        <a href="https://github.com/jneuendorf/FormValidator" class="btn">View on GitHub</a>
        <a href="https://github.com/jneuendorf/FormValidator/zipball/master" class="btn">Download .zip</a>
        <a href="https://github.com/jneuendorf/FormValidator/tarball/master" class="btn">Download .tar.gz</a>
    </section>

    <section class="main-content">
        <!-- Nav tabs -->
        <ul class="nav nav-tabs" role="tablist">
            <?php
                foreach ($tabs as $idx => $tab) {
                    ?>
                    <li role="presentation" class="<?php echo $idx === 0 ? 'active' : ''; ?>">
                        <a href="#<?php echo $tab; ?>" aria-controls="<?php echo $tab; ?>" role="tab" data-toggle="tab"><?php echo $tab; ?></a>
                    </li>
                    <?php
                }
            ?>
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <?php
                foreach ($tabs as $idx => $tab) {
                    ?>
                    <div role="tabpanel" class="tab-pane <?php echo $idx === 0 ? 'active' : ''; ?>" id="<?php echo $tab; ?>">
                        <!-- <h3>
                            <a id="<?php echo $tab; ?>" class="anchor" href="#<?php echo $tab; ?>" aria-hidden="true">
                                <span aria-hidden="true" class="octicon octicon-link"></span>
                            </a>
                            <?php echo $tab; ?>
                        </h3> -->
                        <?php readfile($tab.'.php') ?>
                    </div>
                    <?php
                }
            ?>
        </div>

        <footer class="site-footer">
            <span class="site-footer-owner"><a href="https://github.com/jneuendorf/FormValidator">Formvalidator</a> is maintained by <a href="https://github.com/jneuendorf">jneuendorf</a>.</span>

            <span class="site-footer-credits">This page is based on the <a href="https://github.com/jasonlong/cayman-theme">Cayman theme</a> by <a href="https://twitter.com/jasonlong">Jason Long</a>.</span>
        </footer>
    </section>
    <script type="text/javascript">
        SyntaxHighlighter.defaults["toolbar"] = false;
        SyntaxHighlighter.defaults["gutter"] = false;
        SyntaxHighlighter.all();
    </script>
</body>
</html>
