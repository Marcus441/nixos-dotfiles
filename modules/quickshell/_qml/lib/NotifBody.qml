import QtQuick
import qs

// the one renderer for a notification body, so every view draws the same
// thing: Pango markup (what notify-send's callers write) as Qt styled text
Text {
    id: root

    required property string body

    text: root.styled(root.body)
    textFormat: Text.StyledText
    elide: Text.ElideRight
    color: Config.textSecondary
    font.family: Config.fontFamily
    font.pixelSize: Config.fontSize

    function styled(body: string): string {
        const closers = [];
        return body.replace(/&(?![a-zA-Z]+;|#\d+;|#x[0-9a-fA-F]+;)/g, "&amp;").replace(/<(?![a-zA-Z/])/g, "&lt;").replace(/\r?\n/g, "<br>").replace(/<span\b([^>]*)>|<\/span\s*>/gi, (_, attrs) => attrs === undefined ? (closers.pop() ?? "") : root.openSpan(attrs, closers)).replace(/<\/?(?!(?:b|i|u|s|a|br|p|big|small|sub|sup|strong|em|del|font|ul|ol|li|pre|h[1-6])\b)[a-zA-Z][^>]*>/g, "");
    }

    // a span becomes the styled tags its attributes map onto; the matching
    // close tags wait on the stack for the span's own </span>
    function openSpan(attrs: string, closers: var): string {
        const re = /(\w+)\s*=\s*(["'])(.*?)\2/g;
        let open = "";
        let close = "";
        let m;
        while ((m = re.exec(attrs)) !== null) {
            const value = m[3].toLowerCase();
            let tag = "";
            switch (m[1].toLowerCase()) {
            case "color":
            case "foreground":
            case "fgcolor":
                open += `<font color="${m[3].replace(/["<>]/g, "")}">`;
                close = "</font>" + close;
                continue;
            case "weight":
            case "font_weight":
                if (/^(semi|ultra)?bold$|^(ultra)?heavy$/.test(value) || Number(value) >= 600)
                    tag = "b";
                break;
            case "style":
            case "font_style":
                if (value === "italic" || value === "oblique")
                    tag = "i";
                break;
            case "underline":
                if (value !== "none")
                    tag = "u";
                break;
            case "strikethrough":
                if (value === "true")
                    tag = "s";
                break;
            case "size":
            case "font_size":
                if (value.includes("small"))
                    tag = "small";
                else if (value.includes("large"))
                    tag = "big";
                break;
            }
            if (tag !== "") {
                open += `<${tag}>`;
                close = `</${tag}>` + close;
            }
        }
        closers.push(close);
        return open;
    }
}
