(function (hljs) {
    hljs.registerLanguage("bibtex", function (hljs) {
        return {
            case_insensitive: true,
            contains: [
                hljs.QUOTE_STRING_MODE,
                { className: "comment", begin: /%/, end: /$/ },
                { className: "meta", begin: /@[a-z]+/ },
                { className: "attr", begin: /\b[a-z][\w-]*(?=\s*=)/ },
                { className: "number", begin: /\b\d{4}\b/ }
            ]
        };
    });
})(hljs);
