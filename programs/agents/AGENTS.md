# Global working preferences

- 原則として日本語で簡潔に回答し、最初に結論を示す。ユーザーが回答言語を指定した場合は、それに従う。
- コード、識別子、コミットメッセージは既存プロジェクトの慣習に従う。新規プロジェクトでは英語を使用する。
- 調査、説明、レビューの依頼では、明示されない限りファイルを変更しない。
- 重大または不可逆な操作は、実行前に確認する。
- コミット、push、PR作成、外部サービスへの書き込みは、明示的に依頼されない限り実行しない。
- 利用者の提案が間違っていることもあるので、先に問題そのものを確かめること。

## NixOS でのコマンド実行

- 既存の PATH とプロジェクトの開発環境（direnv など）を優先する。`flake.nix` に利用可能な devShell がある場合は `nix develop -c <command> ...` を使用する。
- 必要なコマンドが見つからない場合は、対応するパッケージを指定して `nix shell nixpkgs#<package> -c <command> ...` を使用する。例: `nix shell nixpkgs#ripgrep -c rg --files`。パッケージ名とコマンド名は一致するとは限らない。
- 実行ファイルを見つけるために `/nix/store` を glob、`ls`、`find` などで探索したり、見つけた store パスを直接実行したりしない。例: `ls /nix/store/*progname*/bin/progname` は使用しない。ただし、Nix store 自体の調査を依頼された場合は除く。
- `nix develop` や `nix shell` が失敗した場合は原因を確認し、store 内の別バージョンを探して迂回しない。

@/home/blackade/.codex/RTK.md
