" Symmetric companion to yats's typescriptImportBlock: a region that matches
" the `{ … }` part of `export { … } from '…'`, with `type` as a contained
" keyword inside it. Without this, the global typescriptAliasKeyword fires on
" the inline `type` modifier inside named-export braces and opens
" typescriptAliasDeclaration, whose region ends at the next `=` — causing the
" highlighting bleed through `from`, the source string, and into following
" lines.

syntax region typescriptExportBlock
  \ matchgroup=typescriptBraces
  \ start=/{/ end=/}/
  \ contained
  \ contains=typescriptIdentifierName,typescriptImportType,typescriptString
  \ nextgroup=typescriptImport
  \ skipwhite skipnl skipempty

syntax clear typescriptExport
syntax keyword typescriptExport export
  \ nextgroup=typescriptExportType,typescriptExportBlock
  \ skipwhite

hi def link typescriptExport Keyword
