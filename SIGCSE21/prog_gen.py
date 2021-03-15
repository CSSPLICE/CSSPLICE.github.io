import csv
import html

body = """
<!DOCTYPE html>
<html>
  <meta charset="UTF-8">
  <head>
    <title>Seventh SPLICE Workshop</title>
    <link href="../cssplice.css" rel="stylesheet" type="text/css">
  </head>
  <body>
    <div id="content">
      <h1>Seventh SPLICE Workshop Proceedings</h1>
      <h2>Proceedings Citation</h2>
      <big>C. Shaffer, P. Brusilovsky, K. Koedinger, S. Edwards.
      <i>Proceedings of SPLICE 2021 workshop CS Education Infrastructure for All III: From Ideas to Practice</i>
      at 52nd ACM Technical Symposium on Computer Science Education, March 15-16, 2021, Virtual Event</big>
      
      <p><b>Organizers</b><br/>
        Cliff Shaffer, Virginia Tech<br/>
        Peter Brusilovsky, University of Pittsburgh<br/>
        Ken Koedinger, Carnegie Mellon University<br/>
        Steve Edwards, Virginia Tech
      </p>
"""

with open("splice_sigcse21.csv", encoding="utf-8",errors='ignore') as file:
    papers = csv.DictReader(file)
    last_category = ""
    for row in papers:
        title = html.escape(row["Title"])
        authors = html.escape(row["Authors"])
        category = html.escape(row["Category"])
        abstract = html.escape(row["Abstract"]).replace("\n", "<br/>\n")
        slides_link = row["SlidesLink"]

        paper_link = "proc/SPLICE2021_SIGCSE_paper_" + row["Number"] + ".pdf"

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

with open("proceedings.html", 'w', encoding="utf8") as file:
    file.write(body)