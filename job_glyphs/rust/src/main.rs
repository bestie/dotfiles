use std::io::{self, BufRead};

const DEFAULT_GLYPH: &str = "⚙";

const APP_GLYPHS: [(&str, &str); 56] = [
    ("vim", ""),
    ("nvim", ""),
    ("vi", ""),
    ("bash", ""),
    ("fish", "󰈺"),
    ("less", "󰅮"),
    ("tmux", ""),
    ("java", ""),
    ("lua", ""),
    ("node", ""),
    ("rails", ""),
    ("rake", "󱕄"),
    ("bundle", ""),
    ("gem", ""),
    ("cargo", ""),
    ("clang", ""),
    ("clangd", ""),
    ("gcc", ""),
    ("g++", ""),
    ("git", ""),
    ("make", ""),
    ("docker", ""),
    ("mysql", ""),
    ("postgres", ""),
    ("redis", ""),
    ("sqlite3", ""),
    ("kafka", "󱀏"),
    ("bash", ""),
    ("c", ""),
    ("c#", ""),
    ("c++", ""),
    ("clojure", ""),
    ("clojurescript", ""),
    ("dart", ""),
    ("elixir", ""),
    ("erlang", ""),
    ("fish", ""),
    ("go", ""),
    ("haskell", ""),
    ("java", ""),
    ("javascript", ""),
    ("julia", ""),
    ("lua", ""),
    ("node", ""),
    ("ocaml", "λ"),
    ("php", ""),
    ("python", ""),
    ("ruby", ""),
    ("rust", ""),
    ("scala", ""),
    ("sh", ""),
    ("swift", ""),
    ("typescript", ""),
    ("vim", ""),
    ("zsh", ""),
    ("emacs", ""),
];

fn main() {
    let lines = io::stdin().lock().lines().map(|line| line.unwrap());

    let output = jobs_to_glyphs(lines);

    println!("{}", output);
}

fn jobs_to_glyphs(lines: impl Iterator<Item = String>) -> String {
    let lines = lines.filter(|line| !line.is_empty());
    let glyphs = lines_to_glyphs(lines);
    join_with_new_lines(glyphs)
}

fn join_with_new_lines<'a>(strings: impl Iterator<Item = &'a str>) -> String {
    strings.fold(String::new(), |joined, glyph| joined + glyph + "\n")
}

fn lines_to_glyphs<'a>(lines: impl Iterator<Item = String>) -> impl Iterator<Item = &'static str> {
    lines.map(|job| search_glyphs(job.split_whitespace().next().unwrap().to_string()))
}

fn search_glyphs(job_name: String) -> &'static str {
    APP_GLYPHS
        .iter()
        .find(|(app_name, _)| app_name.eq(&job_name))
        .map(|(_, glyph)| glyph)
        .unwrap_or(&DEFAULT_GLYPH)
}

#[cfg(test)]
mod tests {
    use crate::jobs_to_glyphs;

    #[test]
    fn test_empty() {
        let input = [""];
        let strings = input.into_iter().map(|s| s.to_string());
        let glyphs = jobs_to_glyphs(strings);
        assert_eq!("", glyphs);
    }

    #[test]
    fn test_args() {
        let input = ["rails console", "nvim app/controllers/users_controller.rb"];
        let strings = input.into_iter().map(|s| s.to_string());
        let glyphs = jobs_to_glyphs(strings);
        assert_eq!("\n\n", glyphs);
    }

    #[test]
    fn test_vim() {
        let input = ["vim"];
        let strings = input.into_iter().map(|s| s.to_string());
        let glyphs = jobs_to_glyphs(strings);
        assert_eq!("\n", glyphs);
    }
    #[test]
    fn test_default_glyph() {
        let input = ["foo", "bar"];
        let strings = input.into_iter().map(|s| s.to_string());
        let glyphs = jobs_to_glyphs(strings);
        assert_eq!("⚙\n⚙\n", glyphs);
    }
}
