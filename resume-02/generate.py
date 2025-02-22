# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "jsonschema",
# ]
# ///

import json
import sys
from pathlib import Path
from string import Template

import jsonschema

# Define constant variables for file paths
CWD = Path(__file__).parent
RESUME_JSON = CWD.parent / "resume.json"
RESUME_SCHEMA_JSON = CWD.parent / "resume.schema.json"
TEMPLATE_FILE = CWD / "template.tex"
OUTPUT_FILE = CWD / "output.tex"

# Define templates for experiences and projects
EXPERIENCE_TEMPLATE = Template(r"""
        \cvevent{$title at \textbf{$company}}{}{$date}{}
            \begin{itemize}
            $points
            \end{itemize}
""")
PROJECTS_TEMPLATE = Template(r"""
        \cvevent{\href{$project_url}{\color{black}{\faGithub} {$title}}}{$subtitle}{}{}
            \begin{itemize}
            $points
            \end{itemize}
""")
EDUCATION_TEMPLATE = Template(r"""
            \cvevent{$from}{$degree}{$date \hspace{1 cm} $grade}{}
""")
CERTIFICATION_TEMPLATE = Template(r"""
        \cvevent{$title}{}{$date}{}
        $description
""")


def load_placeholders(placeholder_json):
    """Function to load placeholder values from a JSON file"""
    return json.loads(placeholder_json.read_bytes())


def format_experiences(experiences):
    """Function to format the experiences section"""
    formatted_experiences = []
    for i in experiences:
        points = "\n            ".join(rf"\item {point}" for point in i.pop("points"))
        formatted_experiences.append(
            EXPERIENCE_TEMPLATE.substitute(**i, points=points),
        )
    return "\n        \\divider\n".join(formatted_experiences)


def format_projects(projects):
    """Function to format the projects section"""
    formatted_projects = []
    for i in projects:
        points = "\n            ".join(rf"\item {point}" for point in i.pop("points"))
        formatted_projects.append(
            PROJECTS_TEMPLATE.substitute(**i, points=points),
        )
    return "\n        \\divider\n".join(formatted_projects)


def format_educations(educations):
    formatted = []
    for i in educations:
        formatted.append(EDUCATION_TEMPLATE.substitute(**i))
    return "\n            \\divider".join(formatted)


def format_certifications(certifications):
    formatted = []
    for i in certifications:
        formatted.append(CERTIFICATION_TEMPLATE.substitute(**i))
    return "\n        \\divider".join(formatted)


def format_techinal_skills(technical_skills):
    formatted = []
    for i in technical_skills:
        formatted.append(rf"\cvtag{{{i}}}")
    return "\n            ".join(formatted)


def format_tools(tools):
    formatted = []
    for i in tools:
        formatted.append(rf"\cvtag{{{i}}}")
    return "\n            ".join(formatted)


def format_course_work(course_works):
    formatted = [r"\begin{itemize}"]
    for i in course_works:
        formatted.append(rf"\item {i}")
    formatted.append(r"\end{itemize}")
    return "\n            ".join(formatted)


def clean_tex_file(content: str) -> str:
    """Remove comments and blank lines from `.tex` file."""
    return "\n".join(
        i for i in content.split("\n") if not i.lstrip(" ").startswith("%")
    )


def fill_template(template_file, output_file, placeholders):
    """Function to fill the LaTeX template"""
    template_content = Template(template_file.read_text())

    # Prepare formatted content for experiences and projects
    placeholders["EXPERIENCES"] = format_experiences(placeholders.pop("experiences"))
    placeholders["PROJECTS"] = format_projects(placeholders.pop("projects"))
    placeholders["EDUCATIONS"] = format_educations(placeholders.pop("educations"))
    placeholders["CERTIFICATIONS"] = format_certifications(
        placeholders.pop("certifications"),
    )
    placeholders["COURSE_WORKS"] = format_course_work(placeholders.pop("course_works"))

    skills = placeholders.pop("technical_skills")
    # first pop tools and then concat all others for tech skills
    placeholders["TOOLS"] = format_tools(skills.pop("Developer Tools"))
    placeholders["TECHNICAL_SKILLS"] = format_techinal_skills(
        [j for i in skills.values() for j in i],
    )

    # Perform the substitution using the placeholders
    filled_content = template_content.safe_substitute(
        {k.upper(): v for k, v in placeholders.items()},
    )

    # Remove tex file comments
    content = clean_tex_file(filled_content)
    # Write the filled content to the output file
    output_file.write_text(content)


def validate_schema(resume_path: Path, schema_path: Path) -> None:
    """Validate JSON schema. Raises error if invalid and exit the program."""
    resume_data = json.loads(resume_path.read_bytes())
    schema = json.loads(schema_path.read_bytes())

    try:
        jsonschema.validate(instance=resume_data, schema=schema)
    except jsonschema.ValidationError as e:
        print("JSON is invalid. Error:", e.message, file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    validate_schema(RESUME_JSON, RESUME_SCHEMA_JSON)
    # Load placeholder values
    placeholders = load_placeholders(RESUME_JSON)

    # Fill the template and generate the output file
    fill_template(TEMPLATE_FILE, OUTPUT_FILE, placeholders)

    print(f"Filled LaTeX file has been saved as {OUTPUT_FILE}")
