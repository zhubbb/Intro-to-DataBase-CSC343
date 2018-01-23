let $rdoc := doc("resume.xml")
return 
<rareskills numresumes="{count($rdoc//resume)}">
{

let $pdoc := doc("posting.xml")


let $highskill:=
for $skill in $rdoc//skill
where $skill/@level >3 
return $skill

for $reqSkill in $pdoc//reqSkill
let $h := count($highskill[$reqSkill/@what=./@what])
let $sameskill := count($rdoc//resume[$reqSkill/@what=./skills/skill/@what])
where $h < (count($rdoc//resume) div 2)
 
return
  <posting pID="{$reqSkill/parent::posting/@pID}" skill="{$reqSkill/@what}" numwith="{$sameskill}" numhigh="{$h}" />

}
</rareskills>


(::)
