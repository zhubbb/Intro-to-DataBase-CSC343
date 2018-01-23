<report>
{
let $rdoc := doc("resume.xml")
let $pdoc := doc("posting.xml")
let $idoc := doc("interview.xml")


for $interview in $idoc//interview
let $person := $rdoc//resume[@rID=$interview/@rID]
let $sameperson := $person//skill
let $posting := $pdoc//posting[@pID=$interview/@pID]
let $sameposting := $posting/reqSkill
return

<interview>	

     <who rID="{$interview/@rID}" forename="{$person//forename}" surname="{$person//surname}"/>
     <position>
        {data($posting/position)}
     </position>

    <match>{
let $score := 
        for $skill in $sameposting	
       return if ($sameperson[@what=$skill/@what]/@level>=$skill/@level)
       then data($skill/@importance)
	else -1*data($skill/@importance)
return sum($score)
     }</match>
     <average>{
	(sum($interview/assessment/answers/*)+sum($interview//assessment/*[name(.)!="answers"])) div
        (count($interview//assessment/*[name(.)!="answers"])+count($interview/assessment/answers/*))}
     </average>
</interview>
	
}
</report>
