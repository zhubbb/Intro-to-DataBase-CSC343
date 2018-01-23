<histogram>
{
let $rdoc := doc("resume.xml")
let $pdoc := doc("posting.xml")
let $distinct := distinct-values($pdoc//reqSkill/@what)

for $reqSkill in $distinct
let $count1 := count($rdoc//resume[./skills/skill[@what=$reqSkill and @level=1]])
let $count2 := count($rdoc//resume[./skills/skill[@what=$reqSkill and @level=2]])
let $count3 := count($rdoc//resume[./skills/skill[@what=$reqSkill and @level=3]])
let $count4 := count($rdoc//resume[./skills/skill[@what=$reqSkill and @level=4]])
let $count5 := count($rdoc//resume[./skills/skill[@what=$reqSkill and @level=5]])

return

  <skill name="{$reqSkill}">
     <count level="1" n="{$count1}" />
     <count level="2" n="{$count2}" />	
     <count level="3" n="{$count3}" />
     <count level="4" n="{$count4}" />
     <count level="5" n="{$count5}" />	
  </skill>
}
</histogram>
