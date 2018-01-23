<collegiality>
{
let $idoc := doc("interview.xml")
let $is := $idoc/interviews/interview

for $interviewer in $idoc//interviewer
where some $i in $is satisfies $i/@sID=$interviewer/@sID and not($i//collegiality)

return
  <forgot sid="{$interviewer/@sID}"/>

}
</collegiality>
