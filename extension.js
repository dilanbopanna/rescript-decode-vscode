const vscode = require("vscode");
const { languages, commands, workspace } = vscode;

const decodeFunction = require("./src/decodeFunction.bs");

class CodelensProvider {
  constructor() {
    this.codeLenses = [];
    this.regex = /type\s+(\w+)\s+=\s+\{/g;

    this._onDidChangeCodeLenses = new vscode.EventEmitter();
    this.onDidChangeCodeLenses = this._onDidChangeCodeLenses.event;

    vscode.workspace.onDidChangeConfiguration((_) => {
      this._onDidChangeCodeLenses.fire();
    });
  }

  provideCodeLenses(document, token) {
    if (
      vscode.workspace
        .getConfiguration("rescript-decode")
        .get("enableDecodeButton", true)
    ) {
      this.codeLenses = [];
      const regex = new RegExp(this.regex);
      const text = document.getText();

      let matches;
      while ((matches = regex.exec(text)) !== null) {
        const line = document.lineAt(document.positionAt(matches.index).line);
        const indexOf = line.text.indexOf(matches[0]);
        const position = new vscode.Position(line.lineNumber, indexOf);
        const range = document.getWordRangeAtPosition(
          position,
          new RegExp(this.regex)
        );
        if (range) {
          this.codeLenses.push(new vscode.CodeLens(range));
        }
      }
      return this.codeLenses;
    }
    return [];
  }

  resolveCodeLens(codeLens, token) {
    if (
      vscode.workspace
        .getConfiguration("rescript-decode")
        .get("enableDecodeButton", true)
    ) {
      const document = vscode.window.activeTextEditor.document;
      const currentLine = document.lineAt(codeLens.range.start.line).text;
      codeLens.command = {
        title: "Generate Decode",
        tooltip: "Click to generate decode function",
        command: "rescript-decode.generateDecode",
        arguments: [currentLine, false],
      };
      return codeLens;
    }
    return null;
  }
}

function activate(context) {
  const codelensProvider = new CodelensProvider();

  languages.registerCodeLensProvider("*", codelensProvider);

  commands.registerCommand("rescript-decode.enableDecodeButton", () => {
    workspace
      .getConfiguration("rescript-decode")
      .update("enableDecodeButton", true, true);
  });

  commands.registerCommand("rescript-decode.generateDecode", (args) => {
    const regex = /type\s+(\w+)\s+=/; // Regular expression to match the type name
    const editor = vscode.window.activeTextEditor;
    if (!editor) {
      vscode.window.showErrorMessage("No active editor found.");
      return;
    }
    const match = args.match(regex);
    if (match) {
      const typeName = match[1];
      const fileContents = editor.document.getText();

      let result = decodeFunction.generateDecode(typeName, fileContents);
      let res = `open LogicUtils // Import Utilities from your Utils file
        ${result}
        `;
      vscode.env.clipboard.writeText(res).then(() => {
        vscode.window.showInformationMessage(
          `${typeName} : Generated code copied to clipboard.`
        );
      });
    } else {
      vscode.window.showErrorMessage("No Type Found");
    }
  });
}

function deactivate() {}

module.exports = {
  activate,
  deactivate,
};
