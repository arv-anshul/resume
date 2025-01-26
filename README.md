# Resume Generator

Write your details in [`placeholder.json`](placeholder.json) and generate your CV using `python` script. _(Isn't it
simple)_

After generating the final `output.tex` file you can go to platforms like [Overleaf.com](https://overleaf.com) to render
it in PDF format to see the final result and make changes here and there according to your need and download it.

## Usage

1. Fill [`placeholder.json`](placeholder.json) with your details.
2. There are multiple CV's that you can generate using same `placeholder.json` by just using Python. Just choose one and
   run below command to generate `output.tex` file in respective directory.
   ```bash
   python run resume-01/generate.py
   ```
3. Copy the contents of generated `output.tex` and paste it to [Overleaf.com](https://overleaf.com) (or your know
   platform) to render it as PDF and make changes as you want.
   > \[!CAUTION\]
   >
   > Some resume might require extra packages like [resume-02](resume-02/) require both `output.tex` and `altacv.cls` to
   > build successfully. So you need to copy both the files on the platform (Overleaf.com).
4. Download the rendered PDF and you are ready to send it in Job applications.

## Acknowledgements

- I have used a modified version of [@sb2nov](https://github.com/sb2nov/resume)'s resume.
- I use [Overleaf.com](https://overleaf.com) to render, edit and download the TeX files.
- Thanks to the LaTeX community for the great tools and resources.
- Inspired by various LaTeX resume templates.

## License

This project is licensed under the [MIT License](LICENSE).
