//
//  FileIcons.swift
//  Commitment
//
//  Created by Stef Kors on 16/10/2023.
//

import Foundation
import SwiftUI

struct FileLanguage {
    let language: String
    let ids: [String]
    let defaultExtension: String
    let filename: String

    init(
        lang: String,
        ids: [String],
        defaultExtension: String
    ) {
        self.language = lang
        self.ids = ids
        self.defaultExtension = defaultExtension
        self.filename = "file_type_\(lang)"
    }
    
    init(
        lang: String,
        ids: String,
        defaultExtension: String
    ) {
        self.language = lang
        self.ids = [ids]
        self.defaultExtension = defaultExtension
        self.filename = "file_type_\(lang)"
    }
}

let fileLanguages: [String: FileLanguage] = [
    "as": FileLanguage(
        lang: "actionscript",
        ids: "actionscript",
        defaultExtension: "as"
    ), 
    "ada": FileLanguage(
        lang: "ada",
        ids: "ada",
        defaultExtension: "ada"
    ), 
    "prw": FileLanguage(
        lang: "advpl",
        ids: "advpl",
        defaultExtension: "prw"
    ), 
    "affect": FileLanguage(
        lang: "affectscript",
        ids: "affectscript",
        defaultExtension: "affect"
    ), 
    "al": FileLanguage(
        lang: "al",
        ids: "al",
        defaultExtension: "al"
    ), 
    "ansible": FileLanguage(
        lang: "ansible",
        ids: "ansible",
        defaultExtension: "ansible"
    ), 
    "g4": FileLanguage(
        lang: "antlr",
        ids: "antlr",
        defaultExtension: "g4"
    ), 
    "any": FileLanguage(
        lang: "anyscript",
        ids: "anyscript",
        defaultExtension: "any"
    ), 
    "htaccess": FileLanguage(
        lang: "apache",
        ids: "apacheconf",
        defaultExtension: "htaccess"
    ),
//    "cls": FileLanguage(
//        lang: "apex",
//        ids: "apex",
//        defaultExtension: "cls"
//    ), 
    "apib": FileLanguage(
        lang: "apib",
        ids: "apiblueprint",
        defaultExtension: "apib"
    ), 
    "apl": FileLanguage(
        lang: "apl",
        ids: "apl",
        defaultExtension: "apl"
    ), 
    "applescript": FileLanguage(
        lang: "applescript",
        ids: "applescript",
        defaultExtension: "applescript"
    ), 
    "adoc": FileLanguage(
        lang: "asciidoc",
        ids: "asciidoc",
        defaultExtension: "adoc"
    ), 
    "asp": FileLanguage(
        lang: "asp",
        ids: [
            "asp",
            "asp (html)"
        ],
        defaultExtension: "asp"
    ), 
    "asm": FileLanguage(
        lang: "assembly",
        ids: [
            "arm",
            "asm",
            "asm-intel-x86-generic",
            "platformio-debug.asm",
            "asm-collection",
        ],
        defaultExtension: "asm"
    ), 
    "ats": FileLanguage(
        lang: "ats",
        ids: ["ats"],
        defaultExtension: "ats"
    ), 
    "ahk": FileLanguage(
        lang: "autohotkey",
        ids: "ahk",
        defaultExtension: "ahk"
    ), 
    "au3": FileLanguage(
        lang: "autoit",
        ids: "autoit",
        defaultExtension: "au3"
    ), 
    "avcs": FileLanguage(
        lang: "avro",
        ids: "avro",
        defaultExtension: "avcs"
    ), 
    "azcli": FileLanguage(
        lang: "azcli",
        ids: "azcli",
        defaultExtension: "azcli"
    ), 
    "azure-pipelines.yml": FileLanguage(
        lang: " azurepipelines",
        ids: "azure-pipelines",
        defaultExtension: "azure-pipelines.yml"
    ), 
    "bal": FileLanguage(
        lang: "ballerina",
        ids: "ballerina",
        defaultExtension: "bal"
    ), 
    "bat": FileLanguage(
        lang: "bat",
        ids: "bat",
        defaultExtension: "bat"
    ), 
    "bats": FileLanguage(
        lang: "bats",
        ids: "bats",
        defaultExtension: "bats"
    ), 
    "bzl": FileLanguage(
        lang: "bazel",
        ids: "bazel",
        defaultExtension: "bzl"
    ), 
    "bf": FileLanguage(
        lang: "befunge",
        ids: [
            "befunge",
            "befunge98"
        ],
        defaultExtension: "bf"
    ), 
    "bicep": FileLanguage(
        lang: "bicep",
        ids: "bicep",
        defaultExtension: "bicep"
    ), 
    "bib": FileLanguage(
        lang: "bibtex",
        ids: "bibtex",
        defaultExtension: "bib"
    ), 
    "biml": FileLanguage(
        lang: "biml",
        ids: "biml",
        defaultExtension: "biml"
    ), 
    "blade.php": FileLanguage(
        lang: "blade",
        ids: [
            "blade",
            "laravel-blade"
        ],
        defaultExtension: "blade.php"
    ), 
    "blitzbasic": FileLanguage(
        lang: "blitzbasic",
        ids: ["blitzbasic"],
        defaultExtension: "blitzbasic"
    ), 
    "bolt": FileLanguage(
        lang: "bolt",
        ids: "bolt",
        defaultExtension: "bolt"
    ), 
    "bsq": FileLanguage(
        lang: "bosque",
        ids: "bosque",
        defaultExtension: "bsq"
    ), 
    "buf.yaml": FileLanguage(
        lang: "buf",
        ids: [
            "buf",
            "buf-gen"
        ],
        defaultExtension: "buf.yaml"
    ), 
    "c": FileLanguage(
        lang: "c",
        ids: "c",
        defaultExtension: "c"
    ), 
    "cal": FileLanguage(
        lang: "c_al",
        ids: "c-al",
        defaultExtension: "cal"
    ), 
    "cabal": FileLanguage(
        lang: "cabal",
        ids: "cabal",
        defaultExtension: "cabal"
    ), 
    "Caddyfile": FileLanguage(
        lang: "caddyfile",
        ids: "caddyfile",
        defaultExtension: "Caddyfile"
    ), 
    "casc": FileLanguage(
        lang: "casc",
        ids: "casc",
        defaultExtension: "casc"
    ), 
    "cddl": FileLanguage(
        lang: "cddl",
        ids: "cddl",
        defaultExtension: "cddl"
    ), 
    "ceylon": FileLanguage(
        lang: "ceylon",
        ids: "ceylon",
        defaultExtension: "ceylon"
    ), 
    "cfc": FileLanguage(
        lang: "cfc",
        ids: "cfc",
        defaultExtension: "cfc"
    ), 
    "cfm": FileLanguage(
        lang: "cfm",
        ids: ["cfmhtml"],
        defaultExtension: "cfm"
    ), 
    "clojure": FileLanguage(
        lang: "clojure",
        ids: "clojure",
        defaultExtension: "clojure"
    ), 
    "clojurescript": FileLanguage(
        lang: "clojurescript",
        ids: "clojurescript",
        defaultExtension: "clojurescript"
    ), 
    "yml": FileLanguage(
        lang: "cloudfoundrymanifest",
        ids: "manifest-yaml",
        defaultExtension: "yml"
    ), 
    "cmake": FileLanguage(
        lang: "cmake",
        ids: "cmake",
        defaultExtension: "cmake"
    ), 
    "CMakeCache.txt": FileLanguage(
        lang: "cmakecache",
        ids: "cmake-cache",
        defaultExtension: "CMakeCache.txt"
    ), 
    "cbl": FileLanguage(
        lang: "cobol",
        ids: "cobol",
        defaultExtension: "cbl"
    ), 
    "ql": FileLanguage(
        lang: "codeql",
        ids: "ql",
        defaultExtension: "ql"
    ), 
    "coffee": FileLanguage(
        lang: "coffeescript",
        ids: "coffeescript",
        defaultExtension: "coffee"
    ), 
    "cfml": FileLanguage(
        lang: "coldfusion",
        ids: [
            "cfml",
            "lang-cfml"
        ],
        defaultExtension: "cfml"
    ), 
    "confluence": FileLanguage(
        lang: "confluence",
        ids: ["confluence"],
        defaultExtension: "confluence"
    ), 
    "ckbk": FileLanguage(
        lang: "cookbook",
        ids: "cookbook",
        defaultExtension: "ckbk"
    ), 
    "cpp": FileLanguage(
        lang: "cpp",
        ids: "cpp",
        defaultExtension: "cpp"
    ), 
    "cr": FileLanguage(
        lang: "crystal",
        ids: "crystal",
        defaultExtension: "cr"
    ), 
    "cs": FileLanguage(
        lang: "csharp",
        ids: "csharp",
        defaultExtension: "cs"
    ), 
    "css": FileLanguage(
        lang: "css",
        ids: "css",
        defaultExtension: "css"
    ), 
    "feature": FileLanguage(
        lang: "cucumber",
        ids: "feature",
        defaultExtension: "feature"
    ), 
    "cu": FileLanguage(
        lang: "cuda",
        ids: [
            "cuda",
            "cuda-cpp"
        ],
        defaultExtension: "cu"
    ), 
    "pyx": FileLanguage(
        lang: "cython",
        ids: "cython",
        defaultExtension: "pyx"
    ), 
    "dal": FileLanguage(
        lang: "dal",
        ids: "dal",
        defaultExtension: "dal"
    ), 
    "dart": FileLanguage(
        lang: "dart",
        ids: "dart",
        defaultExtension: "dart"
    ), 
    "dhall": FileLanguage(
        lang: "dhall",
        ids: "dhall",
        defaultExtension: "dhall"
    ), 
//    "html": FileLanguage(
//        lang: "django",
//        ids: [
//            "django-html",
//            "django-txt"
//        ],
//        defaultExtension: "html"
//    ), 
    "diff": FileLanguage(
        lang: "diff",
        ids: "diff",
        defaultExtension: "diff"
    ), 
    "d": FileLanguage(
        lang: "dlang",
        ids: [
            "d",
            "dscript",
            "dml",
            "diet"
        ],
        defaultExtension: "d"
    ), 
    "dockerfile": FileLanguage(
        lang: "dockerfile",
        ids: "dockerfile",
        defaultExtension: "dockerfile"
    ), 
    "dtx": FileLanguage(
        lang: "doctex",
        ids: "doctex",
        defaultExtension: "dtx"
    ), 
    "env": FileLanguage(
        lang: "dotenv",
        ids: [
            "dotenv",
            "env"
        ],
        defaultExtension: "env"
    ), 
    "dot": FileLanguage(
        lang: "dotjs",
        ids: "dotjs",
        defaultExtension: "dot"
    ), 
    "dox": FileLanguage(
        lang: "doxygen",
        ids: "doxygen",
        defaultExtension: "dox"
    ), 
    "drl": FileLanguage(
        lang: "drools",
        ids: "drools",
        defaultExtension: "drl"
    ), 
    "dust": FileLanguage(
        lang: "dustjs",
        ids: "dustjs",
        defaultExtension: "dust"
    ), 
    "dylan": FileLanguage(
        lang: "dylanlang",
        ids: [
            "dylan",
            "dylan-lid"
        ],
        defaultExtension: "dylan"
    ), 
    "earthfile": FileLanguage(
        lang: "earthfile",
        ids: "earthfile",
        defaultExtension: "earthfile"
    ), 
    "edge": FileLanguage(
        lang: "edge",
        ids: "edge",
        defaultExtension: "edge"
    ), 
    "eex": FileLanguage(
        lang: "eex",
        ids: [
            "eex",
            "html-eex"
        ],
        defaultExtension: "eex"
    ), 
    "es": FileLanguage(
        lang: "elastic",
        ids: "es",
        defaultExtension: "es"
    ), 
    "ex": FileLanguage(
        lang: "elixir",
        ids: "elixir",
        defaultExtension: "ex"
    ), 
    "elm": FileLanguage(
        lang: "elm",
        ids: "elm",
        defaultExtension: "elm"
    ), 
    "erb": FileLanguage(
        lang: "erb",
        ids: [
            "erb",
            "html.erb"
        ],
        defaultExtension: "erb"
    ), 
    "erl": FileLanguage(
        lang: "erlang",
        ids: "erlang",
        defaultExtension: "erl"
    ), 
//    "yaml": FileLanguage(
//        lang: "esphome",
//        ids: "esphome",
//        defaultExtension: "yaml"
//    ), 
    "falcon": FileLanguage(
        lang: "falcon",
        ids: "falcon",
        defaultExtension: "falcon"
    ), 
    "fql": FileLanguage(
        lang: "fauna",
        ids: "fql",
        defaultExtension: "fql"
    ), 
    "f": FileLanguage(
        lang: "fortran",
        ids: [
            "fortran",
            "fortran-modern",
            "FortranFreeForm",
            "FortranFixedForm",
            "fortran_fixed-form",
        ],
        defaultExtension: "f"
    ), 
    "ftl": FileLanguage(
        lang: "freemarker",
        ids: "ftl",
        defaultExtension: "ftl"
    ), 
    "fs": FileLanguage(
        lang: "fsharp",
        ids: "fsharp",
        defaultExtension: "fs"
    ), 
    "fthtml": FileLanguage(
        lang: "fthtml",
        ids: "fthtml",
        defaultExtension: "fthtml"
    ), 
    "gspec": FileLanguage(
        lang: "galen",
        ids: "galen",
        defaultExtension: "gspec"
    ), 
    "gml": FileLanguage(
        lang: "gamemaker",
        ids: "gml-gms",
        defaultExtension: "gml"
    ), 
//    "gml": FileLanguage(
//        lang: "gamemaker2",
//        ids: "gml-gms2",
//        defaultExtension: "gml"
//    ), 
//    "gml": FileLanguage(
//        lang: "gamemaker81",
//        ids: "gml-gm81",
//        defaultExtension: "gml"
//    ), 
    "gcode": FileLanguage(
        lang: "gcode",
        ids: "gcode",
        defaultExtension: "gcode"
    ), 
    "gen": FileLanguage(
        lang: "genstat",
        ids: "genstat",
        defaultExtension: "gen"
    ), 
    "git": FileLanguage(
        lang: "git",
        ids: [
            "git-commit",
            "git-rebase",
            "ignore"
        ],
        defaultExtension: "git"
    ), 
    "glsl": FileLanguage(
        lang: "glsl",
        ids: "glsl",
        defaultExtension: "glsl"
    ), 
    "glyphs": FileLanguage(
        lang: "glyphs",
        ids: "glyphs",
        defaultExtension: "glyphs"
    ), 
    "gp": FileLanguage(
        lang: "gnuplot",
        ids: "gnuplot",
        defaultExtension: "gp"
    ), 
    "go": FileLanguage(
        lang: "go",
        ids: "go",
        defaultExtension: "go"
    ), 
    "api": FileLanguage(
        lang: "goctl",
        ids: "goctl",
        defaultExtension: "api"
    ), 
    "gd": FileLanguage(
        lang: "gdscript",
        ids: "gdscript",
        defaultExtension: "gd"
    ), 
    "gr": FileLanguage(
        lang: "grain",
        ids: "grain",
        defaultExtension: "gr"
    ), 
    "gql": FileLanguage(
        lang: "graphql",
        ids: "graphql",
        defaultExtension: "gql"
    ), 
    "gv": FileLanguage(
        lang: "graphviz",
        ids: "dot",
        defaultExtension: "gv"
    ), 
    "groovy": FileLanguage(
        lang: "groovy",
        ids: "groovy",
        defaultExtension: "groovy"
    ), 
    "haml": FileLanguage(
        lang: "haml",
        ids: "haml",
        defaultExtension: "haml"
    ), 
    "hbs": FileLanguage(
        lang: "handlebars",
        ids: "handlebars",
        defaultExtension: "hbs"
    ), 
    "prg": FileLanguage(
        lang: "harbour",
        ids: "harbour",
        defaultExtension: "prg"
    ), 
    "hs": FileLanguage(
        lang: "haskell",
        ids: "haskell",
        defaultExtension: "hs"
    ), 
    "haxe": FileLanguage(
        lang: "haxe",
        ids: [
            "haxe",
            "hxml",
            "Haxe AST dump"
        ],
        defaultExtension: "haxe"
    ), 
    "hcl": FileLanguage(
        lang: "hcl",
        ids: ["hcl"],
        defaultExtension: "hcl"
    ), 
    "helm.tpl": FileLanguage(
        lang: "helm",
        ids: "helm",
        defaultExtension: "helm.tpl"
    ), 
    "hjson": FileLanguage(
        lang: "hjson",
        ids: "hjson",
        defaultExtension: "hjson"
    ), 
    "hlsl": FileLanguage(
        lang: "hlsl",
        ids: "hlsl",
        defaultExtension: "hlsl"
    ), 
//    "yaml": FileLanguage(
//        lang: "homeassistant",
//        ids: "home-assistant",
//        defaultExtension: "yaml"
//    ), 
    "hosts": FileLanguage(
        lang: "hosts",
        ids: "hosts",
        defaultExtension: "hosts"
    ), 
    "html": FileLanguage(
        lang: "html",
        ids: "html",
        defaultExtension: "html"
    ), 
    "http": FileLanguage(
        lang: "http",
        ids: "http",
        defaultExtension: "http"
    ), 
    "aff": FileLanguage(
        lang: "hunspell",
        ids: [
            "hunspell.aff",
            "hunspell.dic"
        ],
        defaultExtension: "aff"
    ), 
    "hy": FileLanguage(
        lang: "hy",
        ids: "hy",
        defaultExtension: "hy"
    ), 
    "hypr": FileLanguage(
        lang: "hypr",
        ids: "hypr",
        defaultExtension: "hypr"
    ), 
    "icl": FileLanguage(
        lang: "icl",
        ids: "icl",
        defaultExtension: "icl"
    ), 
    "imba": FileLanguage(
        lang: "imba",
        ids: "imba",
        defaultExtension: "imba"
    ), 
    "4gl": FileLanguage(
        lang: "informix",
        ids: "4GL",
        defaultExtension: "4gl"
    ), 
    "ini": FileLanguage(
        lang: "ini",
        ids: "ini",
        defaultExtension: "ini"
    ), 
    "ink": FileLanguage(
        lang: "ink",
        ids: "ink",
        defaultExtension: "ink"
    ), 
    "iss": FileLanguage(
        lang: "innosetup",
        ids: "innosetup",
        defaultExtension: "iss"
    ), 
    "io": FileLanguage(
        lang: "io",
        ids: "io",
        defaultExtension: "io"
    ), 
    "janet": FileLanguage(
        lang: "janet",
        ids: "janet",
        defaultExtension: "janet"
    ), 
    "java": FileLanguage(
        lang: "java",
        ids: "java",
        defaultExtension: "java"
    ), 
    "js": FileLanguage(
        lang: "javascript",
        ids: "javascript",
        defaultExtension: "js"
    ), 
    "jsx": FileLanguage(
        lang: "javascriptreact",
        ids: "javascriptreact",
        defaultExtension: "jsx"
    ), 
    "jekyll": FileLanguage(
        lang: "jekyll",
        ids: "jekyll",
        defaultExtension: "jekyll"
    ), 
    "jenkins": FileLanguage(
        lang: "jenkins",
        ids: [
            "jenkins",
            "declarative",
            "jenkinsfile"
        ],
        defaultExtension: "jenkins"
    ),
    "jinja": FileLanguage(
        lang: "jinja",
        ids: [
            "jinja",
            "jinja-html",
            "jinja-xml",
            "jinja-css",
            "jinja-json",
            "jinja-md",
            "jinja-py",
            "jinja-rb",
            "jinja-js",
            "jinja-yaml",
            "jinja-toml",
            "jinja-latex",
            "jinja-lua",
            "jinja-properties",
            "jinja-shell",
            "jinja-dockerfile",
            "jinja-sql",
            "jinja-terraform",
            "jinja-nginx",
            "jinja-groovy",
            "jinja-systemd",
            "jinja-cpp"],
        defaultExtension: "jinja"
    ),
    "json": FileLanguage(
        lang: "json",
        ids: "json",
        defaultExtension: "json"
    ), 
    "jsonc": FileLanguage(
        lang: "jsonc",
        ids: "jsonc",
        defaultExtension: "jsonc"
    ), 
    "jsonnet": FileLanguage(
        lang: "jsonnet",
        ids: "jsonnet",
        defaultExtension: "jsonnet"
    ), 
    "json5": FileLanguage(
        lang: "json5",
        ids: "json5",
        defaultExtension: "json5"
    ), 
    "jl": FileLanguage(
        lang: "julia",
        ids: [
            "julia",
            "juliamarkdown"
        ],
        defaultExtension: "jl"
    ), 
    "id": FileLanguage(
        lang: "iodine",
        ids: "iodine",
        defaultExtension: "id"
    ), 
    "k": FileLanguage(
        lang: "k",
        ids: "k",
        defaultExtension: "k"
    ), 
    "kv": FileLanguage(
        lang: "kivy",
        ids: "kivy",
        defaultExtension: "kv"
    ), 
    "ks": FileLanguage(
        lang: "kos",
        ids: "kos",
        defaultExtension: "ks"
    ), 
    "kt": FileLanguage(
        lang: "kotlin",
        ids: [
            "kotlin",
            "kotlinscript"
        ],
        defaultExtension: "kt"
    ), 
    ".kusto": FileLanguage(
        lang: "kusto",
        ids: "kusto",
        defaultExtension: ".kusto"
    ), 
    "tex": FileLanguage(
        lang: "latex",
        ids: "latex",
        defaultExtension: "tex"
    ), 
    "lat": FileLanguage(
        lang: "latino",
        ids: "latino",
        defaultExtension: "lat"
    ), 
    "less": FileLanguage(
        lang: "less",
        ids: "less",
        defaultExtension: "less"
    ), 
    "flex": FileLanguage(
        lang: "lex",
        ids: "lex",
        defaultExtension: "flex"
    ), 
    "ly": FileLanguage(
        lang: "lilypond",
        ids: "lilypond",
        defaultExtension: "ly"
    ), 
    "lisp": FileLanguage(
        lang: "lisp",
        ids: [
            "lisp",
            "autolisp",
            "autolispdcl"
        ],
        defaultExtension: "lisp"
    ), 
    "lhs": FileLanguage(
        lang: "literatehaskell",
        ids: ["literate haskell"],
        defaultExtension: "lhs"
    ), 
    "log": FileLanguage(
        lang: "log",
        ids: "log",
        defaultExtension: "log"
    ), 
    "lol": FileLanguage(
        lang: "lolcode",
        ids: "lolcode",
        defaultExtension: "lol"
    ), 
    "lsl": FileLanguage(
        lang: "lsl",
        ids: "lsl",
        defaultExtension: "lsl"
    ), 
    "lua": FileLanguage(
        lang: "lua",
        ids: "lua",
        defaultExtension: "lua"
    ), 
    "mk": FileLanguage(
        lang: "makefile",
        ids: "makefile",
        defaultExtension: "mk"
    ), 
    "md": FileLanguage(
        lang: "markdown",
        ids: "markdown",
        defaultExtension: "md"
    ), 
    "marko": FileLanguage(
        lang: "marko",
        ids: "marko",
        defaultExtension: "marko"
    ), 
    "mat": FileLanguage(
        lang: "matlab",
        ids: "matlab",
        defaultExtension: "mat"
    ), 
    "ms": FileLanguage(
        lang: "maxscript",
        ids: "maxscript",
        defaultExtension: "ms"
    ), 
    "mdx": FileLanguage(
        lang: "mdx",
        ids: "mdx",
        defaultExtension: "mdx"
    ), 
    "mediawiki": FileLanguage(
        lang: "mediawiki",
        ids: "mediawiki",
        defaultExtension: "mediawiki"
    ), 
    "mel": FileLanguage(
        lang: "mel",
        ids: "mel",
        defaultExtension: "mel"
    ), 
    "mmd": FileLanguage(
        lang: "mermaid",
        ids: "mermaid",
        defaultExtension: "mmd"
    ), 
    "meson.build": FileLanguage(
        lang: "meson",
        ids: "meson",
        defaultExtension: "meson.build"
    ), 
    "mjml": FileLanguage(
        lang: "mjml",
        ids: "mjml",
        defaultExtension: "mjml"
    ), 
    "pq": FileLanguage(
        lang: "mlang",
        ids: ["powerquery"],
        defaultExtension: "pq"
    ), 
    "mojo": FileLanguage(
        lang: "mojo",
        ids: "mojo",
        defaultExtension: "mojo"
    ), 
    "ep": FileLanguage(
        lang: "mojolicious",
        ids: "mojolicious",
        defaultExtension: "ep"
    ), 
    "mongo": FileLanguage(
        lang: "mongo",
        ids: "mongo",
        defaultExtension: "mongo"
    ), 
    "mson": FileLanguage(
        lang: "mson",
        ids: "mson",
        defaultExtension: "mson"
    ), 
    "ne": FileLanguage(
        lang: "nearley",
        ids: "nearley",
        defaultExtension: "ne"
    ), 
    "nim": FileLanguage(
        lang: "nim",
        ids: "nim",
        defaultExtension: "nim"
    ), 
    "nimble": FileLanguage(
        lang: "nimble",
        ids: "nimble",
        defaultExtension: "nimble"
    ), 
    "nix": FileLanguage(
        lang: "nix",
        ids: "nix",
        defaultExtension: "nix"
    ), 
    "nsi": FileLanguage(
        lang: "nsis",
        ids: [
            "nsis",
            "nfl",
            "nsl",
            "bridlensis"
        ],
        defaultExtension: "nsi"
    ), 
    "nunjucks": FileLanguage(
        lang: "nunjucks",
        ids: "nunjucks",
        defaultExtension: "nunjucks"
    ), 
    "m": FileLanguage(
        lang: "objectivec",
        ids: "objective-c",
        defaultExtension: "m"
    ), 
    "mm": FileLanguage(
        lang: "objectivecpp",
        ids: "objective-cpp",
        defaultExtension: "mm"
    ), 
    "ml": FileLanguage(
        lang: "ocaml",
        ids: [
            "ocaml",
            "ocamllex",
            "menhir"
        ],
        defaultExtension: "ml"
    ), 
    "o3": FileLanguage(
        lang: "ogone",
        ids: "ogone",
        defaultExtension: "o3"
    ), 
    "w": FileLanguage(
        lang: "openEdge",
        ids: "abl",
        defaultExtension: "w"
    ), 
    "things": FileLanguage(
        lang: "openHAB",
        ids: "openhab",
        defaultExtension: "things"
    ), 
    "pas": FileLanguage(
        lang: "pascal",
        ids: [
            "pascal",
            "objectpascal"
        ],
        defaultExtension: "pas"
    ), 
    "pddl": FileLanguage(
        lang: "pddl",
        ids: "pddl",
        defaultExtension: "pddl"
    ), 
    "plan": FileLanguage(
        lang: "pddlplan",
        ids: "plan",
        defaultExtension: "plan"
    ), 
    "happenings": FileLanguage(
        lang: "pddlhappenings",
        ids: "happenings",
        defaultExtension: "happenings"
    ), 
    "pl": FileLanguage(
        lang: "perl",
        ids: "perl",
        defaultExtension: "pl"
    ), 
    "pl6": FileLanguage(
        lang: "perl6",
        ids: "perl6",
        defaultExtension: "pl6"
    ), 
    "pgsql": FileLanguage(
        lang: "pgsql",
        ids: "pgsql",
        defaultExtension: "pgsql"
    ), 
    "php": FileLanguage(
        lang: "php",
        ids: "php",
        defaultExtension: "php"
    ), 
    "pine": FileLanguage(
        lang: "pine",
        ids: [
            "pine",
            "pinescript"
        ],
        defaultExtension: "pine"
    ), 
    "requirements.txt": FileLanguage(
        lang: "pip",
        ids: "pip-requirements",
        defaultExtension: "requirements.txt"
    ), 
    "txt": FileLanguage(
        lang: "plaintext",
        ids: "plaintext",
        defaultExtension: "txt"
    ), 
    "dbgasm": FileLanguage(
        lang: "platformio",
        ids: [
            "platformio-debug.disassembly",
            "platformio-debug.memoryview",
            "platformio-debug.asm",
        ],
        defaultExtension: "dbgasm"
    ), 
    "ddl": FileLanguage(
        lang: "plsql",
        ids: [
            "plsql",
            "oracle",
            "oraclesql"
        ],
        defaultExtension: "ddl"
    ), 
    "polymer": FileLanguage(
        lang: "polymer",
        ids: "polymer",
        defaultExtension: "polymer"
    ), 
    "pony": FileLanguage(
        lang: "pony",
        ids: "pony",
        defaultExtension: "pony"
    ), 
    "pcss": FileLanguage(
        lang: "postcss",
        ids: "postcss",
        defaultExtension: "pcss"
    ), 
    "ps1": FileLanguage(
        lang: "powershell",
        ids: "powershell",
        defaultExtension: "ps1"
    ), 
    "prisma": FileLanguage(
        lang: "prisma",
        ids: "prisma",
        defaultExtension: "prisma"
    ), 
    "pde": FileLanguage(
        lang: "processinglang",
        ids: "pde",
        defaultExtension: "pde"
    ), 
    "pro": FileLanguage(
        lang: "prolog",
        ids: "prolog",
        defaultExtension: "pro"
    ), 
    "rules": FileLanguage(
        lang: "prometheus",
        ids: "prometheus",
        defaultExtension: "rules"
    ), 
    "properties": FileLanguage(
        lang: "properties",
        ids: "properties",
        defaultExtension: "properties"
    ), 
    "proto": FileLanguage(
        lang: "protobuf",
        ids: [
            "proto3",
            "proto"
        ],
        defaultExtension: "proto"
    ), 
    "pug": FileLanguage(
        lang: "pug",
        ids: "jade",
        defaultExtension: "pug"
    ), 
    "pp": FileLanguage(
        lang: "puppet",
        ids: "puppet",
        defaultExtension: "pp"
    ), 
    "purs": FileLanguage(
        lang: "purescript",
        ids: "purescript",
        defaultExtension: "purs"
    ), 
    "arr": FileLanguage(
        lang: "pyret",
        ids: "pyret",
        defaultExtension: "arr"
    ), 
    "py": FileLanguage(
        lang: "python",
        ids: "python",
        defaultExtension: "py"
    ), 
    "pyowo": FileLanguage(
        lang: "pythowo",
        ids: "pythowo",
        defaultExtension: "pyowo"
    ), 
    "qvs": FileLanguage(
        lang: "qlik",
        ids: "qlik",
        defaultExtension: "qvs"
    ), 
    "qml": FileLanguage(
        lang: "qml",
        ids: "qml",
        defaultExtension: "qml"
    ), 
    "qs": FileLanguage(
        lang: "qsharp",
        ids: "qsharp",
        defaultExtension: "qs"
    ), 
    "r": FileLanguage(
        lang: "r",
        ids: "r",
        defaultExtension: "r"
    ), 
    "rkt": FileLanguage(
        lang: "racket",
        ids: "racket",
        defaultExtension: "rkt"
    ), 
    "cshtml": FileLanguage(
        lang: "razor",
        ids: [
            "razor",
            "aspnetcorerazor"
        ],
        defaultExtension: "cshtml"
    ), 
    "raml": FileLanguage(
        lang: "raml",
        ids: "raml",
        defaultExtension: "raml"
    ), 
    "re": FileLanguage(
        lang: "reason",
        ids: "reason",
        defaultExtension: "re"
    ), 
    "red": FileLanguage(
        lang: "red",
        ids: "red",
        defaultExtension: "red"
    ), 
    "res": FileLanguage(
        lang: "rescript",
        ids: "rescript",
        defaultExtension: "res"
    ), 
    "rst": FileLanguage(
        lang: "restructuredtext",
        ids: "restructuredtext",
        defaultExtension: "rst"
    ), 
    "rex": FileLanguage(
        lang: "rexx",
        ids: "rexx",
        defaultExtension: "rex"
    ), 
    "tag": FileLanguage(
        lang: "riot",
        ids: "riot",
        defaultExtension: "tag"
    ), 
    "rmd": FileLanguage(
        lang: "rmd",
        ids: "rmd",
        defaultExtension: "rmd"
    ), 
    "robot": FileLanguage(
        lang: "robot",
        ids: "robot",
        defaultExtension: "robot"
    ), 
    "rb": FileLanguage(
        lang: "ruby",
        ids: "ruby",
        defaultExtension: "rb"
    ), 
    "rs": FileLanguage(
        lang: "rust",
        ids: "rust",
        defaultExtension: "rs"
    ), 
    "san": FileLanguage(
        lang: "san",
        ids: "san",
        defaultExtension: "san"
    ), 
    "sas": FileLanguage(
        lang: "sas",
        ids: "SAS",
        defaultExtension: "sas"
    ), 
    "sbt": FileLanguage(
        lang: "sbt",
        ids: "sbt",
        defaultExtension: "sbt"
    ), 
    "scad": FileLanguage(
        lang: "scad",
        ids: "scad",
        defaultExtension: "scad"
    ), 
    "scala": FileLanguage(
        lang: "scala",
        ids: "scala",
        defaultExtension: "scala"
    ), 
    "sce": FileLanguage(
        lang: "scilab",
        ids: "scilab",
        defaultExtension: "sce"
    ), 
    "scss": FileLanguage(
        lang: "scss",
        ids: "scss",
        defaultExtension: "scss"
    ), 
    "sdl": FileLanguage(
        lang: "sdlang",
        ids: "sdl",
        defaultExtension: "sdl"
    ), 
    "shader": FileLanguage(
        lang: "shaderlab",
        ids: "shaderlab",
        defaultExtension: "shader"
    ), 
    "sh": FileLanguage(
        lang: "shellscript",
        ids: "shellscript",
        defaultExtension: "sh"
    ), 
    "slang": FileLanguage(
        lang: "slang",
        ids: "slang",
        defaultExtension: "slang"
    ), 
    "ice": FileLanguage(
        lang: "slice",
        ids: ["slice"],
        defaultExtension: "ice"
    ), 
    "slim": FileLanguage(
        lang: "slim",
        ids: ["slim"],
        defaultExtension: "slim"
    ), 
    "ss": FileLanguage(
        lang: "silverstripe",
        ids: "silverstripe",
        defaultExtension: "ss"
    ), 
    "sn": FileLanguage(
        lang: "sino",
        ids: "sino",
        defaultExtension: "sn"
    ), 
    "eskip": FileLanguage(
        lang: "skipper",
        ids: ["eskip"],
        defaultExtension: "eskip"
    ), 
    "tpl": FileLanguage(
        lang: "smarty",
        ids: ["smarty"],
        defaultExtension: "tpl"
    ), 
    "snort": FileLanguage(
        lang: "snort",
        ids: ["snort"],
        defaultExtension: "snort"
    ), 
    "sol": FileLanguage(
        lang: "solidity",
        ids: ["solidity"],
        defaultExtension: "sol"
    ), 
    "rq": FileLanguage(
        lang: "sparql",
        ids: "sparql",
        defaultExtension: "rq"
    ), 
//    "properties": FileLanguage(
//        lang: "springbootproperties",
//        ids: "spring-boot-properties",
//        defaultExtension: "properties"
//    ), 
//    "yml": FileLanguage(
//        lang: "springbootpropertiesyaml",
//        ids: "spring-boot-properties-yaml",
//        defaultExtension: "yml"
//    ), 
    "sqf": FileLanguage(
        lang: "sqf",
        ids: "sqf",
        defaultExtension: "sqf"
    ), 
    "sql": FileLanguage(
        lang: "sql",
        ids: "sql",
        defaultExtension: "sql"
    ), 
    "nut": FileLanguage(
        lang: "squirrel",
        ids: "squirrel",
        defaultExtension: "nut"
    ), 
    "stan": FileLanguage(
        lang: "stan",
        ids: "stan",
        defaultExtension: "stan"
    ), 
    "bazel": FileLanguage(
        lang: "starlark",
        ids: "starlark",
        defaultExtension: "bazel"
    ), 
    "do": FileLanguage(
        lang: "stata",
        ids: "stata",
        defaultExtension: "do"
    ), 
    "stencil": FileLanguage(
        lang: "stencil",
        ids: "stencil",
        defaultExtension: "stencil"
    ), 
    "html.stencil": FileLanguage(
        lang: "stencilhtml",
        ids: "stencil-html",
        defaultExtension: "html.stencil"
    ), 
    "st.css": FileLanguage(
        lang: "stylable",
        ids: "stylable",
        defaultExtension: "st.css"
    ), 
    "styled": FileLanguage(
        lang: "styled",
        ids: "source.css.styled",
        defaultExtension: "styled"
    ), 
    "styl": FileLanguage(
        lang: "stylus",
        ids: "stylus",
        defaultExtension: "styl"
    ), 
    "svelte": FileLanguage(
        lang: "svelte",
        ids: "svelte",
        defaultExtension: "svelte"
    ), 
    "swagger": FileLanguage(
        lang: "swagger",
        ids: [
            "Swagger",
            "swagger"
        ],
        defaultExtension: "swagger"
    ), 
    "swift": FileLanguage(
        lang: "swift",
        ids: "swift",
        defaultExtension: "swift"
    ), 
    "swig": FileLanguage(
        lang: "swig",
        ids: "swig",
        defaultExtension: "swig"
    ), 
    "link": FileLanguage(
        lang: "systemd",
        ids: "systemd-unit-file",
        defaultExtension: "link"
    ), 
    "sv": FileLanguage(
        lang: "systemverilog",
        ids: "systemverilog",
        defaultExtension: "sv"
    ), 
    "tt": FileLanguage(
        lang: "t4",
        ids: "t4",
        defaultExtension: "tt"
    ), 
//    "css": FileLanguage(
//        lang: "tailwindcss",
//        ids: "tailwindcss",
//        defaultExtension: "css"
//    ), 
    "teal": FileLanguage(
        lang: "teal",
        ids: "teal",
        defaultExtension: "teal"
    ), 
    "tt3": FileLanguage(
        lang: "templatetoolkit",
        ids: "tt",
        defaultExtension: "tt3"
    ), 
    "tera": FileLanguage(
        lang: "tera",
        ids: "tera",
        defaultExtension: "tera"
    ), 
    "tf": FileLanguage(
        lang: "terraform",
        ids: "terraform",
        defaultExtension: "tf"
    ),
    "sty": FileLanguage(
        lang: "tex",
        ids: "tex",
        defaultExtension: "sty"
    ), 
    "textile": FileLanguage(
        lang: "textile",
        ids: "textile",
        defaultExtension: "textile"
    ), 
    "JSON-tmLanguage": FileLanguage(
        lang: "textmatejson",
        ids: "json-tmlanguage",
        defaultExtension: "JSON-tmLanguage"
    ), 
    "YAML-tmLanguage": FileLanguage(
        lang: "textmateyaml",
        ids: "yaml-tmlanguage",
        defaultExtension: "YAML-tmLanguage"
    ), 
    "Tiltfile": FileLanguage(
        lang: "tiltfile",
        ids: "tiltfile",
        defaultExtension: "Tiltfile"
    ), 
    "toit": FileLanguage(
        lang: "toit",
        ids: "toit",
        defaultExtension: "toit"
    ), 
    "toml": FileLanguage(
        lang: "toml",
        ids: "toml",
        defaultExtension: "toml"
    ), 
    "ttcn3": FileLanguage(
        lang: "ttcn",
        ids: "ttcn",
        defaultExtension: "ttcn3"
    ), 
    "tuc": FileLanguage(
        lang: "tuc",
        ids: "tuc",
        defaultExtension: "tuc"
    ), 
    "twig": FileLanguage(
        lang: "twig",
        ids: "twig",
        defaultExtension: "twig"
    ), 
    "ts": FileLanguage(
        lang: "typescript",
        ids: "typescript",
        defaultExtension: "ts"
    ), 
    "tsx": FileLanguage(
        lang: "typescriptreact",
        ids: "typescriptreact",
        defaultExtension: "tsx"
    ), 
    "typoscript": FileLanguage(
        lang: "typo3",
        ids: "typoscript",
        defaultExtension: "typoscript"
    ), 
    "u": FileLanguage(
        lang: "unison",
        ids: "unison",
        defaultExtension: "u"
    ), 
    "vb": FileLanguage(
        lang: "vb",
        ids: "vb",
        defaultExtension: "vb"
    ), 
    "cls": FileLanguage(
        lang: "vba",
        ids: "vba",
        defaultExtension: "cls"
    ), 
    "wsf": FileLanguage(
        lang: "vbscript",
        ids: "vbscript",
        defaultExtension: "wsf"
    ), 
    "vm": FileLanguage(
        lang: "velocity",
        ids: "velocity",
        defaultExtension: "vm"
    ), 
//    "v": FileLanguage(
//        lang: "verilog",
//        ids: "verilog",
//        defaultExtension: "v"
//    ), 
    "vhdl": FileLanguage(
        lang: "vhdl",
        ids: "vhdl",
        defaultExtension: "vhdl"
    ), 
    "vim": FileLanguage(
        lang: "viml",
        ids: "viml",
        defaultExtension: "vim"
    ), 
    "v": FileLanguage(
        lang: "vlang",
        ids: "v",
        defaultExtension: "v"
    ), 
    "volt": FileLanguage(
        lang: "volt",
        ids: "volt",
        defaultExtension: "volt"
    ), 
    "vue": FileLanguage(
        lang: "vue",
        ids: "vue",
        defaultExtension: "vue"
    ), 
    "wai": FileLanguage(
        lang: "wai",
        ids: ["wai"],
        defaultExtension: "wai"
    ), 
    "wasm": FileLanguage(
        lang: "wasm",
        ids: [
            "wasm",
            "wat"
        ],
        defaultExtension: "wasm"
    ), 
    "wy": FileLanguage(
        lang: "wenyan",
        ids: "wenyan",
        defaultExtension: "wy"
    ), 
    "wgsl": FileLanguage(
        lang: "wgsl",
        ids: "wgsl",
        defaultExtension: "wgsl"
    ), 
    "wt": FileLanguage(
        lang: "wikitext",
        ids: "wikitext",
        defaultExtension: "wt"
    ), 
    "wl": FileLanguage(
        lang: "wolfram",
        ids: "wolfram",
        defaultExtension: "wl"
    ), 
    "wurst": FileLanguage(
        lang: "wurst",
        ids: [
            "wurstlang",
            "wurst"
        ],
        defaultExtension: "wurst"
    ), 
    "wxml": FileLanguage(
        lang: "wxml",
        ids: "wxml",
        defaultExtension: "wxml"
    ), 
    "xmake.lua": FileLanguage(
        lang: "xmake",
        ids: "xmake",
        defaultExtension: "xmake.lua"
    ), 
    "xml": FileLanguage(
        lang: "xml",
        ids: "xml",
        defaultExtension: "xml"
    ), 
    "xquery": FileLanguage(
        lang: "xquery",
        ids: "xquery",
        defaultExtension: "xquery"
    ), 
    "xsl": FileLanguage(
        lang: "xsl",
        ids: "xsl",
        defaultExtension: "xsl"
    ), 
    "bison": FileLanguage(
        lang: "yacc",
        ids: "yacc",
        defaultExtension: "bison"
    ), 
    "yaml": FileLanguage(
        lang: "yaml",
        ids: "yaml",
        defaultExtension: "yaml"
    ), 
    "yang": FileLanguage(
        lang: "yang",
        ids: "yang",
        defaultExtension: "yang"
    ), 
    "zig": FileLanguage(
        lang: "zig",
        ids: "zig",
        defaultExtension: "zig"
    )
]
