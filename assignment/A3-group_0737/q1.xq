<skilled>
{
let $rdoc := doc("resume.xml")

(:we create a for loop here to parse all the resume:)

for $resume in $rdoc//resume
let $c :=count($resume//skill)
## ANNOTATION 2: This should be > 3 ##
where $c>=3
## END ANNOTATION 2 ##

return
  <candidate rid="{data($resume/@rID)}" numskills="{data($c)}">
  <name>{data($resume//forename)}</name> 
  </candidate>
}
</skilled>
