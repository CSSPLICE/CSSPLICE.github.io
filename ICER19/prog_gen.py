import csv
import html

body = """
<!DOCTYPE html>
<html>
  <meta charset="UTF-8">
  <head>
    <title>SPLICE August 2019 Workshop</title>
    <link href="../cssplice.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div id="content">
      <h1>5th SPLICE Workshop Proceedings</h1>
      <h2>Proceedings Citation</h2>
      <big>Brusilovsky, P, T.W. Price, L. Malmi and S. Edwards.
      <i>Proceedings of SPLICE 2019 workshop Computing Science Education Infrastructure: From Tools to Data</i>
      at 15th ACM International Computing Education Research Conference, Aug 11, 2019, Toronto, Canada</big>
      
      <p>
        <b>Organizers:</b><br/>
		Peter Brusilovsky, University of Pittsburgh, USA (<a href="emailto:peterb@pitt.edu">peterb@pitt.edu</a>)<br/>
		Thomas Price, North Carolina State University, USA<br/>
		Lauri Malmi, Aalto University, Finland<br/>
		Steve Edwards, Virginia Tech, USA<br/>
        More information is available at the <a href='../ICER19Workshop.html'>the workshop page</a>.
      </p>
"""

with open("ICER19/splice_icer19.csv", encoding="utf8") as file:
    papers = csv.DictReader(file)
    last_category = ""
    for row in papers:
        title = html.escape(row["Title"])
        authors = html.escape(row["Authors"])
        category = html.escape(row["Category"])
        abstract = html.escape(row["Abstract"]).replace("\n", "<br/>\n")
        slides_link = row["SlidesLink"]

        paper_link = "proc/SPLICE_2019_ICER_paper_" + row["Number"] + ".pdf"

        if last_category != category:
            body += "<h2>%ss</h2>\n" % category
            last_category = category

        slides = ""
        if slides_link != "":
          slides = "<b>Slides</b>: <a href='%s' target='_blank'>Available Here</a><br/>" % (slides_link)

        body += """
        <p>
            <b>Title</b>: <a href="%s" target="_blank">%s</a><br/>
            <b>Authors</b>: %s<br/>
            %s
            <b>Abstract</b>: <small>%s</small>
        </p>""" % (paper_link, title, authors, slides, abstract)

body += """
    </div>
    <div id="footer">
      <p class="footertext">
        Last updated:
        <script type="text/javascript">
          document.write(document.lastModified);
        </script>
      </p>
    </div>

  </body>
</html>
"""
print(body)

with open("ICER19/proceedings.html", 'w', encoding="utf8") as file:
    file.write(body)