<priorities>
{
let $pdoc := doc("posting.xml")

for $reqSkill in $pdoc//reqSkill
where $reqSkill/@importance = max($reqSkill/parent::posting//@importance )

return
## ANNOTATION 3: All skills for a posting should go under one posting tag. ##
  <posting pID="{$reqSkill/parent::posting/data(@pID)}">
	<skill importance="{$reqSkill/@importance}">
	    {$reqSkill/data(@what)}	
	</skill>
  </posting>	
## END ANNOTATION 3 ##
}
</priorities>
