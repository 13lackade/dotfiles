from pathlib import Path
import tomllib
import subprocess

def install_git(data):
    dir = Path(data['path']).expanduser()
    git = data['url']

    if (dir / '.git').exists():
        subprocess.run(['git','pull'],cwd=dir)
    else:
        subprocess.run(['git','clone',git,dir])

def install_script(data):
    dir = Path(data['path']).expanduser()
    script = Path(data['script']).expanduser()

    dir.mkdir(parents=True,exist_ok=True)

    subprocess.run([script],cwd=dir)

def main():
    config_dir = Path('~/.config/plug').expanduser()

    for file in config_dir.iterdir():
        if file.is_dir():
            continue

        with open(file,'rb') as f:
            data = tomllib.load(f)

        for key in data:
            print('installing',key)
            match data[key]['type']:
                case 'git':
                    install_git(data[key])
                case 'script':
                    install_script(data[key])
                case unknown:
                    print('unknown type:',unknown)

main()
