(:for $p in $d/PROPERTIES/PROPERTY
return
for $u in $p//UNIT
return 
$u:)



<COMMERCIAL_UNITS>
{
let $d := fn:doc("property.xml") 
let $p :=  $d/PROPERTIES/PROPERTY[COMMERCIAL]


for $u in $p//(UNIT|SINGLE_UNIT)
return 
<UNIT>



{
$u/INFO
}

{
$u/ancestor::PROPERTY/ADDRESS


}

 




</UNIT>
}
</COMMERCIAL_UNITS>


