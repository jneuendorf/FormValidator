<div id="target_finding_modal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">Target finding</h4>
            </div>
            <div class="modal-body">
                <p>
                    A list of targets is defined as space separated <code>String</code>.<br><br>
                    Each list element <var>E</var> is parsed like so (for a FormValidator <var>F</var>):<br>
                    <ol>
                        <li>tru to find an element in the form of <var>F</var> where the attribute <code>data-fv-name</code> equals <var>E</var></li>
                        <li>otherwise <var>E</var> is interpreted as selector which will be looked for in <var>F</var></li>
                        <li>otherwise <var>E</var> is interpreted as selector which will be looked for in the entire document</li>
                    </ol>
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
