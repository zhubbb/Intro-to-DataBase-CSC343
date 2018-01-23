<missingskills>
{
let $pdoc := doc("posting.xml")
let $rdoc := doc("resume.xml")
let $skill := $rdoc//skill

let $problem := 

	for $reqSkill in $pdoc//reqSkill
	let $sameskill := 
		for $s in $skill 
		where $s/@what = $reqSkill/@what 
		return $s

	where every $ss in $sameskill satisfies $ss/@level < $reqSkill/@level
	return $reqSkill

for $posting in $pdoc//posting

where some $p in $problem satisfies $p/parent::posting/@pID=$posting /@pID
return
  <problemposting pID="{$posting /@pID}">

{for $skills in $problem
where $skills/parent::posting/@pID=$posting /@pID
return
	<skill what="{$skills/@what}"/>}
 
 </problemposting>	
}
</missingskills>

(:where some $s in $skill satisifies not($s/@what = $reqSkill/@what and $s/@level > $reqSkill/@level):)
