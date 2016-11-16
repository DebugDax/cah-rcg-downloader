#include <inet.au3>
#include <string.au3>

$url = 'http://explosm.net/rcg'
$i = 0

DirCreate(@ScriptDir & "\comics")

While 1
	$source = _INetGetSource($url, True)
	if StringInStr($source, '"rcg-comic"') Then
		$img = _StringBetween($source, '"rcg-comic" src="//', '"')
		if IsArray($img) Then
			$name = _StringBetween($img[0], 'rcg/', '.png')
			if IsArray($name) Then
				if not FileExists(@ScriptDir & "\comics\" & $name[0] & ".png") Then
					$i = $i + 1
					ConsoleWrite($i & ": " & $img[0])
					InetGet('http://' & $img[0], @ScriptDir & "\comics\" & $name[0] & ".png", 3, 0)
					$before = round(FileGetSize(@ScriptDir & "\comics\" & $name[0] & ".png") / 1024, 2)

					;If you have pngquant.exe then uncomment the block below. You should really get it.
					#cs
					ShellExecuteWait(@ScriptDir & "\pngquant.exe", '--ext=-new.png --force --skip-if-larger --quality=32-64 "' & @ScriptDir & '\comics\' & $name[0] & '.png"', Null, Null, @SW_HIDE )
					while round(FileGetSize(@ScriptDir & '\comics\' & $name[0] & '.png') / 1024, 2) <= 1
						sleep(10)
					WEnd
					#ce
					$after = round(FileGetSize(@ScriptDir & '\comics\' & $name[0] & '-new.png') / 1024, 2)
					if not @error then
						ConsoleWrite(@TAB & " ... Compressed! [" & $before & " KB => " & $after & " KB]" & @CRLF)
					Else
						ConsoleWrite(@TAB & " ... Skipped Compression! [" & $before & "]" & @CRLF)
					EndIf
					FileMove(@ScriptDir & "\comics\" & $name[0] & "-new.png", @ScriptDir & "\comics\" & $name[0] & ".png", 1)
				Else
					ConsoleWrite('Skipping: ' & $name[0])
				EndIf
			EndIf
		EndIf
	EndIf
	;sleep(Random(1000,2400,1))
WEnd