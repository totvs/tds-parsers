#INCLUDE "CFGX056.CH"

//-- Manutenção Mashups
Function CFGX056()
	Local nPos
	Local aContry  := {}
	Local cCountry := ""

	If cPaisLoc <> "BRA"
		aContry := GetCountryList()
		If (nPos := Ascan( aContry, { |x| x[1] == cPaisLoc } )) > 0
			cCountry := aContry[nPos,2]
		EndIf
		MsgStop( STR0001 + cCountry) // "Opção indisponível para a localização "
		Return
	EndIf

	Return APCFG10("#SXV")