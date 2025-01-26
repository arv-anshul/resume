import json
from pathlib import Path
from string import Template
from typing import Any

# Constants for file paths
CWD = Path(__file__).parent
PLACEHOLDER_JSON = CWD.parent / "placeholder.json"
TEMPLATE_FILE = CWD / "template.tex"
OUTPUT_FILE = CWD / "output.tex"

# Templates for formatting sections
EXPERIENCE_TEMPLATE = Template(r"""
            \resumeSubheading{$title}{$company}{$date}{$extra}
                \resumeItemListStart
                    $points
                \resumeItemListEnd
""")
PROJECT_TEMPLATE = Template(r"""
            \resumeProjectHeading{\textbf{$title} | \emph{$subtitle}}{\href{$project_url}{\faGithub\ Code}}
                \resumeItemListStart
                    $points
                \resumeItemListEnd
""")
TECHNICAL_SKILLS_TEMPLATE = Template(r"\textbf{$category:} {$skills} \\")
EDUCATION_TEMPLATE = Template(r"\resumeSubheading{$from}{$date}{$degree}{$grade}")


def load_placeholders(placeholder_json):
    """Function to load placeholder values from JSON"""
    return json.loads(placeholder_json.read_bytes())


def format_experiences(experiences):
    """Function to format experiences"""
    formatted = []
    for exp in experiences:
        points = "\n                    ".join(
            rf"\resumeItem{{{point}}}" for point in exp.pop("points")
        )
        formatted.append(EXPERIENCE_TEMPLATE.substitute(**exp, points=points))
    return "".join(formatted)


def format_projects(projects):
    """Function to format projects"""
    formatted = []
    for project in projects:
        points = "\n                    ".join(
            rf"\resumeItem{{{point}}}" for point in project.pop("points")
        )
        formatted.append(PROJECT_TEMPLATE.substitute(**project, points=points))
    return "".join(formatted)


def format_technical_skills(technical_skills):
    """Function to format technical skills"""
    formatted = []
    for category, skills in technical_skills.items():
        formatted.append(
            TECHNICAL_SKILLS_TEMPLATE.substitute(
                category=category,
                skills=", ".join(skills),
            ),
        )
    return "\n                ".join(formatted)


def format_education(educations):
    """Function to format education"""
    formatted = []
    for edu in educations:
        formatted.append(EDUCATION_TEMPLATE.substitute(**edu))
    return "\n            ".join(formatted)


def format_course_work(course_works):
    """Function to format course work"""
    formatted = []
    for work in course_works:
        formatted.append(
            rf"\item\small {work}" if len(work) > 20 else rf"\item {work}",
        )
    return "\n                    ".join(formatted)


def clean_tex_file(content: str) -> str:
    """Remove comments and blank lines from `.tex` file."""
    return "\n".join(
        i for i in content.split("\n") if not i.lstrip(" ").startswith("% ") and i
    )


def fill_template(
    template_file: Path,
    output_file: Path,
    placeholders: dict[str, Any],
) -> None:
    """Function to fill the LaTeX template"""
    template_content = Template(template_file.read_text())

    # Prepare formatted content for sections
    placeholders["EXPERIENCES"] = format_experiences(placeholders.pop("experiences"))
    placeholders["PROJECTS"] = format_projects(placeholders.pop("projects"))
    placeholders["TECHNICAL_SKILLS"] = format_technical_skills(
        placeholders.pop("technical_skills"),
    )
    placeholders["EDUCATIONS"] = format_education(placeholders.pop("educations"))
    placeholders["COURSE_WORKS"] = format_course_work(placeholders.pop("course_works"))

    # Substitute placeholders in the template
    filled_content = template_content.safe_substitute(
        {k.upper(): v for k, v in placeholders.items()},
    )

    # Remove tex file comments
    content = clean_tex_file(filled_content)
    # Write the filled content to the output file
    output_file.write_text(content)


if __name__ == "__main__":
    # Load placeholder values
    placeholders = load_placeholders(PLACEHOLDER_JSON)

    # Fill the template and generate the output file
    fill_template(TEMPLATE_FILE, OUTPUT_FILE, placeholders)

    print(f"Filled LaTeX file has been saved at {OUTPUT_FILE!r}.")
