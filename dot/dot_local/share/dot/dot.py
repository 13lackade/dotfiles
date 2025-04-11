from argparse import ArgumentParser
from pathlib import Path

def get_target(root, path):
    start_replace = False
    target = Path(path.parts[0])
    for part in path.parts[1:]:
        if start_replace:
            target /= part.replace('dot_','.')
        else:
            target /= part

        if target == root:
            start_replace = True
            target = Path.home()
    return target

def list_files(path):
    files = []
    for dirpath, _, filenames in path.walk():
        for file in filenames:
            files.append((get_target(path,dirpath / file),dirpath / file))
    return files 

def install(path):
    files = list_files(path)

    for target,file in files:
        print(target,'->',file)
        if target.exists(follow_symlinks=False):
            if target.resolve() == file:
                continue
            else:
                print(target,'already exists and is not symlinked to',file)
                continue
        target.parent.mkdir(parents=True,exist_ok=True)
        target.symlink_to(file)

def uninstall(path):
    files = list_files(path)

    for target,_ in files:
        print('removing',target)
        if not target.exists(follow_symlinks=False):
            continue
        target.unlink()
        for parent in target.parents:
            try:
                parent.rmdir()
            except Exception as e:
                break

def main():
    # parse arguments
    parser = ArgumentParser(
            prog='dot',
            description='blackade\'s dotfile installer')
    parser.add_argument('operation')
    parser.add_argument('packages', nargs='+')

    args = parser.parse_args()

    # get package root
    root = Path('~/.dotfiles/').expanduser()
    if not root.is_dir():
        print('~/.dotfiles is not a directory')
        return

    match args.operation:
        case 'install':
            func = install
        case 'uninstall':
            func = uninstall
        case unknown:
            print('unknown operation:',unknown)
            return

    for package in args.packages:
        package_path = root / package
        if not package_path.is_dir():
            print('package does not exist:',package)
            continue
        func(package_path)

main()
