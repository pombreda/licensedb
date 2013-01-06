
///<reference path='../../upstream/typescript-node-definitions/node.d.ts' />

import main = module('../main');

var assert = require('assert');

function redirect_test(mimetype: string, suffix: string) : void {
    var request = {
        url: 'https://licensedb.org/id/Apache-2',
        headers: { 'Accept': mimetype },
    };

    var expected = {
        status: 303,
        headers: { 'Location': 'https://licensedb.org/id/Apache-2.' + suffix }
    };

    var message = "Accept " + mimetype + " redirects to " + suffix;

    assert.response (main.server, request, expected, message);
};

export function test_404 () : void {
    assert.response(
        main.server,
        { url: 'https://licensedb.org/does/not/exist' },
        { status: 404 },
        "Non-existant url results in 404");
};

export function test_redirects () : void {
    redirect_test( '*/*',                 'html'   );
    redirect_test( 'text/html',           'html'   );
    redirect_test( 'application/json',    'json'   );
    redirect_test( 'application/ld+json', 'jsonld' );
    redirect_test( 'application/rdf+xml', 'rdf'    );
};
