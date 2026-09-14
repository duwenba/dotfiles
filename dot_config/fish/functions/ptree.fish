function ptree --description 'Make a file tree from a pacman package (or piped paths). ptree [package]'
    # 缓存 perl 渲染脚本（只生成一次）
    set -l pl_src "$HOME/.cache/ptree.tree.pl"
    if not test -e "$pl_src"
        mkdir -p (dirname "$pl_src")
        cat > "$pl_src" <<'PERL_SRC'
use strict; use warnings;

# 读取路径并构建目录树
my %tree;
sub add {
    my ($path) = @_;
    $path =~ s{^/++}{};          # 去掉前导 /
    $path =~ s{/++$}{};          # 去掉末尾 /
    my $n = \%tree;
    for my $seg (split m{/}, $path) {
        $n = $n->{$seg} //= {};
    }
    $n->{__F__} = 1;             # 标记为文件（可能是叶子）
}
while (<STDIN>) { chomp; next unless length; add($_); }

# 递归渲染树状视图
my $render;
$render = sub {
    my ($node, $prefix, $top) = @_;
    my @items = sort grep { $_ ne '__F__' } keys %$node;
    my $out = '';
    for my $i (0 .. $#items) {
        my $last = ($i == $#items);
        my $conn = $top ? "" : ($last ? "└── " : "├── ");
        my $ext  = $top ? "" : ($last ? "    " : "│   ");
        $out .= $prefix . $conn . $items[$i] . "\n";
        $out .= $render->($node->{$items[$i]}, $prefix . $ext, 0);
    }
    return $out;
};

print "$_\n" . $render->($tree{$_}, "", 1) for sort keys %tree;
PERL_SRC
    end

    if set -q argv[1]
        pacman -Ql $argv[1] | awk '{print $2}' | sed 's|^/||' | perl "$pl_src"
    else
        awk '{print $2}' | sed 's|^/||' | perl "$pl_src"
    end
end