<#
.DESCRIPTION
    THIS PROGRAM IS DESIGNED TO BE A ONE-STOP-SHOP FOR ALL MLB DECISION MAKING.
.AUTHOR
    TYLER NEELY
.CREATED
    03/2022
#>

$matchupList = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?sportId=1").dates.games
$oddsApi = Invoke-RestMethod -Uri "https://api.the-odds-api.com/v4/sports/baseball_mlb/odds/?apiKey=3e4d3f8e153fcdff13adbb92b200b0fb&regions=us&markets=h2h,spreads,totals&oddsFormat=american&bookmakers=draftkings"
$apiKey  = '3e4d3f8e153fcdff13adbb92b200b0fb'

#Loop through each one of todays games and provide a scouting report
foreach($game in $matchupList){
    #Boiler plate code. Declaration of variables for collecting/ formatting data.
    $secondDate      = Get-Date -Format "d" $game.gameDate
    $datePitcher     = (Get-Date $secondDate).AddDays(-30)
    $fiveDaysBack    = (Get-Date $secondDate).AddDays(-6)
    $formatDatePitcher  = Get-Date -Format "d" $datePitcher
    $formatDateFiveDays = Get-Date -Format "d" $fiveDaysBack
    $gameId          = $game.gamePk
    $extraGmInfo     = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1.1/game/$gameId/feed/live").gameData
    $weater          = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1.1/game/$gameId/feed/live").gameData.weather 
    $awayTeam        = $game.teams.away.team.name
    $awayTeamId      = $game.teams.away.team.id
    $awayTeamStat    = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/stats?stats=season&group=hitting").stats.splits.stat
    $awayTeamRecents = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$awayTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games
    $awayTeamBatRecents = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/stats?group=hitting&stats=byDateRange&startDate=$formatDateFiveDays&endDate=$secondDate").stats.splits.stat
    $awayPlayersRecents = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/stats?stats=lastXGames&group=hitting&teamId=$awayTeamId").stats.splits
    $awayTeamRecord  = [string]$game.teams.away.leagueRecord.wins + '-' + $game.teams.away.leagueRecord.losses
    $homeTeamRecord  = [string]$game.teams.home.leagueRecord.wins + '-' + $game.teams.home.leagueRecord.losses
    $homeTeamRecents = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$homeTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games
    $homeTeam        = $game.teams.home.team.name
    $homeTeamId      = $game.teams.home.team.id
    $homeTeamStat    = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/stats?stats=season&group=hitting").stats.splits.stat
    $homeTeamRecents = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$homeTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games
    $homeTeamBatRecents = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/stats?group=hitting&stats=byDateRange&startDate=$formatDateFiveDays&endDate=$secondDate").stats.splits.stat
    $homePlayersRecents = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/stats?stats=lastXGames&group=hitting&teamId=$homeTeamId").stats.splits
    $homePlayersBatS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/stats?stats=season&group=hitting&teamId=$homeTeamId").stats.splits
    $awayPlayersBatS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/stats?stats=season&group=hitting&teamId=$awayTeamId").stats.splits
    $awayTeamSP      = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1.1/game/$gameId/feed/live").gameData.probablePitchers.away.fullName
    $awaySpLastName  = $awayTeamSP -split " " | Select-Object -Last 1
    $awaySpId        = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1.1/game/$gameId/feed/live").gameData.probablePitchers.away.id
    $awaySpProfile   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId").people
    $awaySpStats     = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=season&group=pitching").stats.splits.stat[0]
    $awaySpCaStats   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=career&group=pitching").stats.splits.stat
    $awaySpGameLog   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=gameLog&group=pitching&startDate=$formatDatePitcher&endDate=$secondDate").stats.splits
    $awaySpGameLog   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=gameLog&group=pitching&startDate=$formatDatePitcher&endDate=$secondDate").stats.splits
    $awaySpHand      = $awaySpProfile.pitchHand.code + 'HP'
    $homeTeamSP      = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1.1/game/$gameId/feed/live").gameData.probablePitchers.home.fullName
    $homeSpLastName  = $homeTeamSP -split " " | Select-Object -Last 1
    $homeSpId        = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1.1/game/$gameId/feed/live").gameData.probablePitchers.home.id
    $homeSpProfile   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId").people
    $homeSpStats     = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId/stats?stats=season&group=pitching").stats.splits.stat[0]
    $homeSpCaStats   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId/stats?stats=career&group=pitching").stats.splits.stat
    $homeSpGameLog   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId/stats?stats=gameLog&group=pitching&startDate=$formatDatePitcher&endDate=$secondDate").stats.splits
    $homeSpHand      = $homeSpProfile.pitchHand.code + 'HP'

    $homeRS   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=runs&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $homeTeam}
    $homeAvgS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=battingAverage&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $homeTeam}
    $homeHrS  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=homeRuns&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $homeTeam}
    $homeSlgS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=slg&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $homeTeam}
    $homeObpS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=obp&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $homeTeam}
    $awayRS   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=runs&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $awayTeam}
    $awayAvgS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=battingAverage&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $awayTeam}
    $awayHrS  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=homeRuns&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $awayTeam}
    $awaySlgS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=slg&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $awayTeam}
    $awayObpS = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/stats/leaders?leaderCategories=obp&statGroup=hitting&limit=33").leagueLeaders.leaders | Where-Object {$_.team.name -eq $awayTeam}
    $awayRankss = $forOdds.competitions.competitors | Where-Object {$_.team.displayName -Like "*$awayTeam*"} 
    $homeRankss = $forOdds.competitions.competitors | Where-Object {$_.team.displayName -Like "*$homeTeam*"}
    $as1 = "1 Home vs " + $awaySpGameLog[0].opponent.name
    $as2 = "2 Home vs " + $awaySpGameLog[1].opponent.name
    $as3 = "3 Home vs " + $awaySpGameLog[2].opponent.name
    $as4 = "4 Home vs " + $awaySpGameLog[3].opponent.name
    $as5 = "5 Home vs " + $awaySpGameLog[4].opponent.name
    $hs1 = "1 Home vs " + $homeSpGameLog[0].opponent.name
    $hs2 = "2 Home vs " + $homeSpGameLog[1].opponent.name
    $hs3 = "3 Home vs " + $homeSpGameLog[2].opponent.name
    $hs4 = "4 Home vs " + $homeSpGameLog[3].opponent.name
    $hs5 = "5 Home vs " + $homeSpGameLog[4].opponent.name
    $awaySpAdv   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=seasonAdvanced&group=pitching").stats.splits.stat[0]
    $awaySpBar   = ($awaySpAdv.lineOuts + $awaySpAdv.lineHits + $awaySpAdv.flyHits + $awaySpAdv.flyOuts) / $awaySpAdv.totalSwings
    $awaySpSab   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=sabermetrics&group=pitching").stats.splits.stat
    $awaySpVsOpp = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=vsTeamTotal&group=pitching&opposingTeamId=$homeTeamId&rosterType=Active").stats.splits.stat
    $homeSpVsOpp = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId/stats?stats=vsTeamTotal&group=pitching&opposingTeamId=$awayTeamId&rosterType=Active").stats.splits.stat
    $homeSpAdv   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId/stats?stats=seasonAdvanced&group=pitching").stats.splits.stat[0]
    $homeSpBar   = ($homeSpAdv.lineOuts + $homeSpAdv.lineHits + $homeSpAdv.flyHits + $homeSpAdv.flyOuts) / $homeSpAdv.totalSwings
    $homeSpSab   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId/stats?stats=sabermetrics&group=pitching").stats.splits.stat

    $homePlayerNRec = $homePlayersRecents | Sort-Object -Descending {$_.stat.atBats} 
    $homePlayerVOSP = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awaySpId/stats?stats=vsPlayer5Y&group=pitching&opposingTeamId=$homeTeamId&rosterType=Active").stats.splits | Sort-Object -Descending {$_.stat.atBats} 
    $homePlayer1N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[0].person.fullname
    $homePlayer1Ns  = $homePlayer1N.Chars(0) + '.' + $homePlayer1N.Split(" ")[1]
    $homePlayer1Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[0].person.id
    $homePlayer1St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homePlayer1Id/stats?stats=season&group=hitting").stats.splits.stat
    $homePlayer1Rr  = $homePlayersRecents | Where-Object {$_.player.fullName -match $homePlayer1N}
    $homeVsS1       = $homePlayerVOSP | Where-Object {$_.batter.fullName -eq $homePlayer1N}
    $homePlayer2N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[1].person.fullname
    $homePlayer2Ns  = $homePlayer2N.Chars(0) + '.' + $homePlayer2N.Split(" ")[1]
    $homePlayer2Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[1].person.id
    $homePlayer2St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homePlayer2Id/stats?stats=season&group=hitting").stats.splits.stat
    $homePlayer2Rr  = $homePlayersRecents | Where-Object {$_.player.fullName -match $homePlayer2N}
    $homeVsS2       = $homePlayerVOSP | Where-Object {$_.batter.fullName -eq $homePlayer2N}
    $homePlayer3N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[2].person.fullname
    $homePlayer3Ns  = $homePlayer3N.Chars(0) + '.' + $homePlayer3N.Split(" ")[1]
    $homePlayer3Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[2].person.id
    $homePlayer3St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homePlayer3Id/stats?stats=season&group=hitting").stats.splits.stat
    $homePlayer3Rr  = $homePlayersRecents | Where-Object {$_.player.fullName -match $homePlayer3N}
    $homeVsS3       = $homePlayerVOSP | Where-Object {$_.batter.fullName -eq $homePlayer3N}
    $homePlayer4N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[3].person.fullname
    $homePlayer4Ns  = $homePlayer4N.Chars(0) + '.' + $homePlayer4N.Split(" ")[1]
    $homePlayer4Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[3].person.id
    $homePlayer4St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homePlayer4Id/stats?stats=season&group=hitting").stats.splits.stat
    $homePlayer4Rr  = $homePlayersRecents | Where-Object {$_.player.fullName -match $homePlayer4N}
    $homeVsS4       = $homePlayerVOSP | Where-Object {$_.batter.fullName -eq $homePlayer4N}
    $homePlayer5N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[4].person.fullname
    $homePlayer5Ns  = $homePlayer5N.Chars(0) + '.' + $homePlayer5N.Split(" ")[1]
    $homePlayer5Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[4].person.id
    $homePlayer5St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homePlayer5Id/stats?stats=season&group=hitting").stats.splits.stat
    $homePlayer5Rr  = $homePlayersRecents | Where-Object {$_.player.fullName -eq $homePlayer5N}
    $homeVsS5       = $homePlayerVOSP | Where-Object {$_.batter.fullName -eq $homePlayer5N}
    $homePlayer6N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[5].person.fullname
    $homePlayer6Ns  = $homePlayer6N.Chars(0) + '.' + $homePlayer6N.Split(" ")[1]
    $homePlayer6Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[5].person.id
    $homePlayer6St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homePlayer6Id/stats?stats=season&group=hitting").stats.splits.stat
    $homePlayer6Rr  = $homePlayersRecents | Where-Object {$_.player.fullName -match $homePlayer6N}
    $homeVsS6       = $homePlayerVOSP | Where-Object {$_.batter.fullName -eq $homePlayer6N}
    $homePlayer7N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[6].person.fullname
    $homePlayer7Ns  = $homePlayer7N.Chars(0) + '.' + $homePlayer7N.Split(" ")[1]
    $homePlayer7Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$homeTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[6].person.id
    $homePlayer7St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homePlayer7Id/stats?stats=season&group=hitting").stats.splits.stat
    $homePlayer7Rr  = $homePlayersRecents | Where-Object {$_.player.fullName -match $homePlayer7N}
    $homeVsS7       = $homePlayerVOSP | Where-Object {$_.batter.fullName -eq $homePlayer7N}
    #home/ away seperation
    $awayPlayerNRec = $awayPlayersRecents | Sort-Object -Descending {$_.stat.atBats} 
    $awayPlayerVOSP = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$homeSpId/stats?stats=vsPlayer5Y&group=pitching&opposingTeamId=$awayTeamId&rosterType=Active").stats.splits | Sort-Object -Descending {$_.stat.atBats} 
    $awayPlayer1N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[0].person.fullname
    $awayPlayer1Ns  = $awayPlayer1N.Chars(0) + '.' + $awayPlayer1N.Split(" ")[1]
    $awayPlayer1Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[0].person.id
    $awayPlayer1St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awayPlayer1Id/stats?stats=season&group=hitting").stats.splits.stat
    $awayPlayer1Rr  = $awayPlayersRecents | Where-Object {$_.player.fullName -match $awayPlayer1N}
    $awayVsS1       = $awayPlayerVOSP | Where-Object {$_.batter.fullName -eq $awayPlayer1N}
    $awayPlayer2N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[1].person.fullname
    $awayPlayer2Ns  = $awayPlayer2N.Chars(0) + '.' + $awayPlayer2N.Split(" ")[1]
    $awayPlayer2Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[1].person.id
    $awayPlayer2St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awayPlayer2Id/stats?stats=season&group=hitting").stats.splits.stat
    $awayPlayer2Rr  = $awayPlayersRecents | Where-Object {$_.player.fullName -match $awayPlayer2N}
    $awayVsS2       = $awayPlayerVOSP | Where-Object {($_.batter.fullName -eq $awayPlayer2N) -and ($_.pitcher.fullName -like "*$homeSpLastName*")} 
    $awayPlayer3N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[2].person.fullname
    $awayPlayer3Ns  = $awayPlayer3N.Chars(0) + '.' + $awayPlayer3N.Split(" ")[1]
    $awayPlayer3Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[2].person.id
    $awayPlayer3St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awayPlayer3Id/stats?stats=season&group=hitting").stats.splits.stat
    $awayPlayer3Rr  = $awayPlayersRecents | Where-Object {$_.player.fullName -match $awayPlayer3N}
    $awayVsS3       = $awayPlayerVOSP | Where-Object {$_.batter.fullName -eq $awayPlayer3N}
    $awayPlayer4N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[3].person.fullname
    $awayPlayer4Ns  = $awayPlayer4N.Chars(0) + '.' + $awayPlayer4N.Split(" ")[1]
    $awayPlayer4Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[3].person.id
    $awayPlayer4St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awayPlayer4Id/stats?stats=season&group=hitting").stats.splits.stat
    $awayPlayer4Rr  = $awayPlayersRecents | Where-Object {$_.player.fullName -match $awayPlayer4N}
    $awayVsS4       = $awayPlayerVOSP | Where-Object {$_.batter.fullName -eq $awayPlayer4N}
    $awayPlayer5N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[4].person.fullname
    $awayPlayer5Ns  = $awayPlayer5N.Chars(0) + '.' + $awayPlayer5N.Split(" ")[1]
    $awayPlayer5Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[4].person.id
    $awayPlayer5St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awayPlayer5Id/stats?stats=season&group=hitting").stats.splits.stat
    $awayPlayer5Rr  = $awayPlayersRecents | Where-Object {$_.player.fullName -eq $awayPlayer5N}
    $awayVsS5       = $awayPlayerVOSP | Where-Object {$_.batter.fullName -eq $awayPlayer5N}
    $awayPlayer6N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[5].person.fullname
    $awayPlayer6Ns  = $awayPlayer6N.Chars(0) + '.' + $awayPlayer6N.Split(" ")[1]
    $awayPlayer6Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[5].person.id
    $awayPlayer6St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awayPlayer6Id/stats?stats=season&group=hitting").stats.splits.stat
    $awayPlayer6Rr  = $awayPlayersRecents | Where-Object {$_.player.fullName -match $awayPlayer6N}
    $awayVsS6       = $awayPlayerVOSP | Where-Object {$_.batter.fullName -eq $awayPlayer6N}
    $awayPlayer7N   = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[6].person.fullname
    $awayPlayer7Ns  = $awayPlayer7N.Chars(0) + '.' + $awayPlayer7N.Split(" ")[1]
    $awayPlayer7Id  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/teams/$awayTeamId/leaders?leaderCategories=atBats&limit=8").teamLeaders[0].leaders[6].person.id
    $awayPlayer7St  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/people/$awayPlayer7Id/stats?stats=season&group=hitting").stats.splits.stat
    $awayPlayer7Rr  = $awayPlayersRecents | Where-Object {$_.player.fullName -match $awayPlayer7N}
    $awayVsS7       = $awayPlayerVOSP | Where-Object {$_.batter.fullName -eq $awayPlayer7N}
    $homeTeamRecAwayTm = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$homeTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.away.team.name
    $homeTeamRecAwayR  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$homeTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.away.score
    $homeTeamRecHomeTm = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$homeTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.home.team.name
    $homeTeamRecHomeR  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$homeTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.home.score
    $awayTeamRecAwayTm = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$awayTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.away.team.name
    $awayTeamRecAwayR  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$awayTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.away.score
    $awayTeamRecHomeTm = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$awayTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.home.team.name
    $awayTeamRecHomeR  = (Invoke-RestMethod -Uri "https://statsapi.mlb.com/api/v1/schedule?stats=byDateRange&sportId=1&teamId=$awayTeamId&startDate=$formatDateFiveDays&endDate=$secondDate").dates.games.teams.home.score


    if($awaySpGameLog[0].isHome -eq 'False'){
        $as1 = $as1.Replace("Home","Away")
    }
    if($awaySpGameLog[1].isHome -eq 'False'){
        $as2 = $as2.Replace("Home","Away")
    }
    if($awaySpGameLog[2].isHome -eq 'False'){
        $as3 = $as3.Replace("Home","Away")
    }
    if($awaySpGameLog[3].isHome -eq 'False'){
        $as4 = $as4.Replace("Home","Away")
    }
    if($awaySpGameLog[4].isHome -eq 'False'){
        $as5 = "....Away vs " + $awaySpGameLog[4].opponent.name
    }
    if($homeSpGameLog[0].isHome -eq 'False'){
        $hs1 = $hs1.Replace("Home","Away")
    }
    if($homeSpGameLog[1].isHome -eq 'False'){
        $hs2 = $hs2.Replace("Home","Away")
    }
    if($homeSpGameLog[2].isHome -eq 'False'){
        $hs3 = $hs3.Replace("Home","Away")
    }
    if($homeSpGameLog[3].isHome -eq 'False'){
        $hs4 = $hs4.Replace("Home","Away")
    }
    if($homeSpGameLog[4].isHome -eq 'False'){
        $hs5 = "5 Away vs " + $homeSpGameLog[4].opponent.name
    }

    #start of custom objects
    $matchupStatss = [PSCustomObject]@{
        'MATCHUP'     = $awayTeam + " ($awayTeamRecord)" + ' @ ' + $homeTeam + " ($homeTeamRecord)"
        'GAME TIME'   = [DateTime]$game.gameDate.Replace(":00 ",'')
        'PROBABLES'   = "$awayTeamSP" + ' vs ' + "$homeTeamSP" 
        'WEATHER'     = $weater.condition + ', ' + $weater.temp + 'F, ' + $weater.wind
        'MONEYLINE'  = $null
        #'OVER/UNDER' = $null
    }
    
    $awayPitcher = [PSCustomObject]@{
        ("$awaySpHand " + $awayTeamSP.ToUpper()) = [string]$awaySpStats.wins + '-' + [string]$awaySpStats.losses 
        'IP'   = $awaySpStats.inningsPitched  
        'ERA'  = $awaySpStats.era
        'QS'   = $awaySpAdv.qualityStarts
        'K/9'  = $awaySpAdv.strikeoutsPer9
        'H/9'  = $awaySpAdv.hitsPer9
        'BB/9' = $awaySpAdv.baseOnBallsPer9
        'AVG'  = $awaySpStats.avg
        'SLG'  = $awaySpAdv.slg
        'BARREL%'  = $awaySpBar.toString("F2")
        'WIFF%'    = ($awaySpAdv.swingAndMisses / $awaySpAdv.totalSwings).ToString("F2") 
        'ERA--'    = ($awaySpSab.eraMinus).ToString("F2")
        #'STRIKE%' = $awaySpAdv.strikePercentage
        #'WHIP'    = $awaySpStats.whip
        #'ISO'     = $awaySpAdv.iso
        #'LAST 5 STARTS' = ' '
        $hs1 = $awaySpGameLog[0].stat.summary + ', ' + $awaySpGameLog[0].stat.hits + ' H' 
        $hs2 = $awaySpGameLog[1].stat.summary + ', ' + $awaySpGameLog[1].stat.hits + ' H'
        $hs3 = $awaySpGameLog[2].stat.summary + ', ' + $awaySpGameLog[2].stat.hits + ' H'
        $hs4 = $awaySpGameLog[3].stat.summary + ', ' + $awaySpGameLog[3].stat.hits + ' H'
        #$hs5 = $awaySpGameLog[4].stat.summary.Replace(' ','') + ',' + $awaySpGameLog[4].stat.hits + 'H'
        'Career'  = $awaySpCaStats.inningsPitched + ' IP, ' + $awaySpCaStats.era + ' ERA, ' + 'WL ' + [string]$awaySpCaStats.wins + '-' + [string]$awaySpCaStats.losses   
        'Career+' = 'AVG ' + $awaySpStats.avg + ', SLG ' + $awaySpCaStats.slg #+ ' HKBB/9:' + [math]::Round($awaySpCaStats.hitsPer9Inn) + ',' + [math]::Round($awaySpCaStats.strikeoutsPer9Inn) + ',' + [math]::Round($awaySpCaStats.walksPer9Inn)
        ('vs ' + $homeTeam) = [string]$awaySpVsOpp.plateAppearances + ' PA, ' + $awaySpVsOpp.rbi + ' R, ' + $awaySpVsOpp.strikeOuts + ' K, ' + $awaySpVsOpp.avg + ' AVG, ' + $awaySpVsOpp.awayRuns + ' HR'  #+ ', SLG ' + $awaySpVsOpp.slg 
    }

    $awayTeamStatss = [PSCustomObject]@{
        ($awayTeam).ToUpper() = 'BATTING'
        "R"   = '#' + "{0:d2}" -f $awayRS.rank   + ' ' + $awayRS.value  
        "AVG" = '#' + "{0:d2}" -f $awayAvgS.rank + ' ' + $awayAvgS.value 
        "HR"  = '#' + "{0:d2}" -f $awayHrS.rank  + ' ' + $awayHrS.value
        "SLG" = '#' + "{0:d2}" -f $awaySlgS.rank + ' ' + $awaySlgS.value 
        "OBP" = '#' + "{0:d2}" -f $awayObpS.rank + ' ' + $awayObpS.value  
        $awayPlayer1N.ToUpper()       = 'AB ' + $awayPlayer1St.atBats + ', AVG ' + $awayPlayer1St.avg + ', HR ' + "{0:d2}" -f $homePlayer1St.homeRuns +
                                        ', SLG ' + $homePlayer1St.slg + ', OBP ' + $homePlayer1St.obp
        ($awayPlayer1Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer1rr.stat.atBats + ', AVG ' + $homePlayer1Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer1Rr.stat.homeRuns +
                                        ', SLG ' + $awayPlayer1Rr.stat.slg + ', OBP ' + $awayPlayer1Rr.stat.obp + ', K ' + "{0:d2}" -f $awayPlayer1Rr.stat.strikeOuts
        ($awayPlayer1Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $awayVsS1.stat.atBats + ', AVG ' + $awayVsS1.stat.avg + ', HR ' + "{0:d2}" -f $awayVsS1.stat.homeRuns +
                                        ', SLG ' + $awayVsS1.stat.slg + ', OBP ' + $awayVsS1.stat.obp + ', K ' + "{0:d2}" -f $awayVsS1.stat.strikeOuts
        $awayPlayer2N.ToUpper()       = 'AB ' + "{0:d3}" -f $awayPlayer2St.atBats + ', AVG ' + $awayPlayer2St.avg + ', HR ' + "{0:d2}" -f $awayPlayer2St.homeRuns +
                                        ', SLG ' + $awayPlayer2St.slg + ', OBP ' + $awayPlayer2St.obp 
        ($awayPlayer2Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $awayPlayer2rr.stat.atBats + ', AVG ' + $awayPlayer2Rr.stat.avg + ', HR ' + "{0:d2}" -f $awayPlayer2Rr.stat.homeRuns +
                                        ', SLG ' + $awayPlayer2Rr.stat.slg + ', OBP ' + $awayPlayer2Rr.stat.obp + ', K ' + "{0:d2}" -f $awayPlayer2Rr.stat.strikeOuts
        ($awayPlayer2Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $awayVsS2.stat.atBats + ', AVG ' + $awayVsS2.stat.avg + ', HR ' + "{0:d2}" -f $awayVsS2.stat.homeRuns +
                                        ', SLG ' + $awayVsS2.stat.slg + ', OBP ' + $awayVsS2.stat.obp + ', K ' + "{0:d2}" -f $awayVsS2.stat.strikeOuts
        $awayPlayer3N.ToUpper()       = 'AB ' + $awayPlayer3St.atBats + ', AVG ' + $awayPlayer3St.avg + ', HR ' + "{0:d2}" -f $awayPlayer3St.homeRuns +
                                        ', SLG ' + $awayPlayer3St.slg + ', OBP ' + $awayPlayer3St.obp 
        ($awayPlayer3Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $awayPlayer3rr.stat.atBats + ', AVG ' + $awayPlayer3Rr.stat.avg + ', HR ' + "{0:d2}" -f $awayPlayer3Rr.stat.homeRuns +
                                        ', SLG ' + $awayPlayer3Rr.stat.slg + ', OBP ' + $awayPlayer3Rr.stat.obp + ', K ' + "{0:d2}" -f $awayPlayer3Rr.stat.strikeOuts
        ($awayPlayer3Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $awayVsS3.stat.atBats + ', AVG ' + $awayVsS3.stat.avg + ', HR ' + "{0:d2}" -f $awayVsS3.stat.homeRuns +
                                        ', SLG ' + $awayVsS3.stat.slg + ', OBP ' + $awayVsS3.stat.obp + ', K ' + "{0:d2}" -f $awayVsS3.stat.strikeOuts
        $awayPlayer4N.ToUpper()       = 'AB ' + $awayPlayer4St.atBats + ', AVG ' + $awayPlayer4St.avg + ', HR ' + "{0:d2}" -f $awayPlayer4St.homeRuns +
                                        ', SLG ' + $awayPlayer4St.slg + ', OBP ' + $awayPlayer4St.obp  
        ($awayPlayer4Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $awayPlayer4rr.stat.atBats + ', AVG ' + $awayPlayer4Rr.stat.avg + ', HR ' + "{0:d2}" -f $awayPlayer4Rr.stat.homeRuns +
                                        ', SLG ' + $awayPlayer4Rr.stat.slg + ', OBP ' + $awayPlayer4Rr.stat.obp + ', K ' + "{0:d2}" -f $awayPlayer4Rr.stat.strikeOuts
        ($awayPlayer4Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $awayVsS4.stat.atBats + ', AVG ' + $awayVsS4.stat.avg + ', HR ' + "{0:d2}" -f $awayVsS4.stat.homeRuns +
                                        ', SLG ' + $awayVsS4.stat.slg + ', OBP ' + $awayVsS4.stat.obp + ', K ' + "{0:d2}" -f $awayVsS4.stat.strikeOuts
        $awayPlayer5N.ToUpper()       = 'AB ' + $awayPlayer5St.atBats + ', AVG ' + $awayPlayer5St.avg + ', HR ' + "{0:d2}" -f $awayPlayer5St.homeRuns +
                                        ', SLG ' + $awayPlayer5St.slg + ', OBP ' + $awayPlayer5St.obp 
        ($awayPlayer5Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $awayPlayer5rr.stat.atBats + ', AVG ' + $awayPlayer5Rr.stat.avg + ', HR ' + "{0:d2}" -f $awayPlayer5Rr.stat.homeRuns +
                                        ', SLG ' + $awayPlayer5Rr.stat.slg + ', OBP ' + $awayPlayer5Rr.stat.obp + ', K ' + "{0:d2}" -f $awayPlayer5Rr.stat.strikeOuts
        ($awayPlayer5Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $awayVsS5.stat.atBats + ', AVG ' + $awayVsS5.stat.avg + ', HR ' + "{0:d2}" -f $awayVsS5.stat.homeRuns +
                                        ', SLG ' + $awayVsS5.stat.slg + ', OBP ' + $awayVsS5.stat.obp + ', K ' + "{0:d2}" -f $awayVsS5.stat.strikeOuts
        $awayPlayer6N.ToUpper()       = 'AB ' + $awayPlayer6St.atBats + ', AVG ' + $awayPlayer6St.avg + ', HR ' + "{0:d2}" -f $awayPlayer6St.homeRuns +
                                        ', SLG ' + $awayPlayer6St.slg + ', OBP ' + $awayPlayer6St.obp 
        ($awayPlayer6Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $awayPlayer6rr.stat.atBats + ', AVG ' + $awayPlayer6Rr.stat.avg + ', HR ' + "{0:d2}" -f $awayPlayer6Rr.stat.homeRuns +
                                        ', SLG ' + $awayPlayer6Rr.stat.slg + ', OBP ' + $awayPlayer6Rr.stat.obp + ', K ' + "{0:d2}" -f $awayPlayer6Rr.stat.strikeOuts
        ($awayPlayer6Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $awayVsS6.stat.atBats + ', AVG ' + $awayVsS6.stat.avg + ', HR ' + "{0:d2}" -f $awayVsS6.stat.homeRuns +
                                        ', SLG ' + $awayVsS6.stat.slg + ', OBP ' + $awayVsS6.stat.obp + ', K ' + "{0:d2}" -f $awayVsS6.stat.strikeOuts
        $awayPlayer7N.ToUpper()       = 'AB ' + $awayPlayer7St.atBats + ', AVG ' + $awayPlayer7St.avg + ', HR ' + "{0:d2}" -f $awayPlayer7St.homeRuns +
                                        ', SLG ' + $awayPlayer7St.slg + ', OBP ' + $awayPlayer7St.obp 
        ($awayPlayer7Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $awayPlayer7rr.stat.atBats + ', AVG ' + $awayPlayer7Rr.stat.avg + ', HR ' + "{0:d2}" -f $awayPlayer7Rr.stat.homeRuns +
                                        ', SLG ' + $awayPlayer7Rr.stat.slg + ', OBP ' + $awayPlayer7Rr.stat.obp + ', K ' + "{0:d2}" -f $awayPlayer7Rr.stat.strikeOuts
        ($awayPlayer7Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $awayVsS7.stat.atBats + ', AVG ' + $awayVsS7.stat.avg + ', HR ' + "{0:d2}" -f $awayVsS7.stat.homeRuns +
                                        ', SLG ' + $awayVsS7.stat.slg + ', OBP ' + $awayVsS7.stat.obp + ', K ' + "{0:d2}" -f $awayVsS7.stat.strikeOuts
        'Last 5 Scores' = 
                           ($awayTeamRecAwayTm[4].Substring(0,3)).toUpper() + ' ' + $awayTeamRecAwayR[4] + ' @ ' + ($awayTeamRecHomeTm[4].Substring(0,3)).toUpper() + ' ' + $awayTeamRecHomeR[4] + ', ' +
                           ($awayTeamRecAwayTm[3].Substring(0,3)).toUpper() + ' ' + $awayTeamRecAwayR[3] + ' @ ' + ($awayTeamRecHomeTm[3].Substring(0,3)).toUpper() + ' ' + $awayTeamRecHomeR[3] + ', ' +
                           ($awayTeamRecAwayTm[2].Substring(0,3)).toUpper() + ' ' + $awayTeamRecAwayR[2] + ' @ ' + ($awayTeamRecHomeTm[2].Substring(0,3)).toUpper() + ' ' + $awayTeamRecHomeR[2] + ', ' +
                           ($awayTeamRecAwayTm[1].Substring(0,3)).toUpper() + ' ' + $awayTeamRecAwayR[1] + ' @ ' + ($awayTeamRecHomeTm[1].Substring(0,3)).toUpper() + ' ' + $awayTeamRecHomeR[1]  

    }

#############                                                 #############             
#############  This seperates the home/ away customobjects    ############# 
#############                                                 #############

    $homePitcher = [PSCustomObject]@{
        ("$homeSpHand " + $homeTeamSP.ToUpper()) = [string]$homeSpStats.wins + '-' + [string]$homeSpStats.losses
        'IP'   = $homeSpStats.inningsPitched  
        'ERA'  = $homeSpStats.era
        'QS'   = $homeSpAdv.qualityStarts
        'K/9'  = $homeSpAdv.strikeoutsPer9
        'H/9'  = $homeSpAdv.hitsPer9
        'BB/9' = $homeSpAdv.baseOnBallsPer9
        'AVG'  = $homeSpStats.avg
        'SLG'  = $homeSpAdv.slg
        'BARREL%' = $homeSpBar.toString("F2")
        'WIFF%'   = ($homeSpAdv.swingAndMisses / $homeSpAdv.totalSwings).ToString("F2") 
        'ERA--'   = ($homeSpSab.eraMinus).ToString("F2")
        #'STRIKE%' = $homeSpAdv.strikePercentage
        #'WHIP'    = $homeSpStats.whip
        #'ISO'     = $homeSpAdv.iso
        #'LAST 5 STARTS' = ' '
        $hs1 = $homeSpGameLog[0].stat.summary + ', ' + $homeSpGameLog[0].stat.hits + ' H' 
        $hs2 = $homeSpGameLog[1].stat.summary + ', ' + $homeSpGameLog[1].stat.hits + ' H'
        $hs3 = $homeSpGameLog[2].stat.summary + ', ' + $homeSpGameLog[2].stat.hits + ' H'
        $hs4 = $homeSpGameLog[3].stat.summary + ', ' + $homeSpGameLog[3].stat.hits + ' H'
        #$hs5 = $homeSpGameLog[4].stat.summary.Replace(' ','') + ',' + $homeSpGameLog[4].stat.hits + 'H'
        'Career'  = $homeSpCaStats.inningsPitched + ' IP, ' + $homeSpCaStats.era + ' ERA, ' + 'WL ' + [string]$homeSpCaStats.wins + '-' + [string]$homeSpCaStats.losses   
        'Career+' = 'AVG ' + $homeSpStats.avg + ', SLG ' + $homeSpCaStats.slg #+ ' HKBB/9:' + [math]::Round($homeSpCaStats.hitsPer9Inn) + ',' + [math]::Round($homeSpCaStats.strikeoutsPer9Inn) + ',' + [math]::Round($homeSpCaStats.walksPer9Inn)
        ('vs ' + $awayTeam) = [string]$homeSpVsOpp.plateAppearances + ' PA, ' + $homeSpVsOpp.rbi + ' R, ' + $homeSpVsOpp.strikeOuts + ' K, ' + $homeSpVsOpp.avg + ' AVG, ' + $homeSpVsOpp.homeRuns + ' HR'  #+ ', SLG ' + $homeSpVsOpp.slg 
    }

    $homeTeamStatss = [PSCustomObject]@{
        ($homeTeam).ToUpper() = 'BATTING'
        "R"   = '#' + "{0:d2}" -f $homeRS.rank   + ' ' + $homeRS.value  
        "AVG" = '#' + "{0:d2}" -f $homeAvgS.rank + ' ' + $homeAvgS.value 
        "HR"  = '#' + "{0:d2}" -f $homeHrS.rank  + ' ' + $homeHrS.value
        "SLG" = '#' + "{0:d2}" -f $homeSlgS.rank + ' ' + $homeSlgS.value 
        "OBP" = '#' + "{0:d2}" -f $homeObpS.rank + ' ' + $homeObpS.value  
        $homePlayer1N.ToUpper()       = 'AB ' + $homePlayer1St.atBats + ', AVG ' + $homePlayer1St.avg + ', HR ' + "{0:d2}" -f $homePlayer1St.homeRuns +
                                        ', SLG ' + $homePlayer1St.slg + ', OBP ' + $homePlayer1St.obp
        ($homePlayer1Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer1rr.stat.atBats + ', AVG ' + $homePlayer1Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer1Rr.stat.homeRuns +
                                        ', SLG ' + $homePlayer1Rr.stat.slg + ', OBP ' + $homePlayer1Rr.stat.obp + ', K ' + "{0:d2}" -f $homePlayer1Rr.stat.strikeOuts
        ($homePlayer1Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $homeVsS1.stat.atBats + ', AVG ' + $homeVsS1.stat.avg + ', HR ' + "{0:d2}" -f $homeVsS1.stat.homeRuns +
                                        ', SLG ' + $homeVsS1.stat.slg + ', OBP ' + $homeVsS1.stat.obp + ', K ' + "{0:d2}" -f $homeVsS1.stat.strikeOuts
        $homePlayer2N.ToUpper()       = 'AB ' + "{0:d3}" -f $homePlayer2St.atBats + ', AVG ' + $homePlayer2St.avg + ', HR ' + "{0:d2}" -f $homePlayer2St.homeRuns +
                                        ', SLG ' + $homePlayer2St.slg + ', OBP ' + $homePlayer2St.obp 
        ($homePlayer2Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer2rr.stat.atBats + ', AVG ' + $homePlayer2Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer2Rr.stat.homeRuns +
                                        ', SLG ' + $homePlayer2Rr.stat.slg + ', OBP ' + $homePlayer2Rr.stat.obp + ', K ' + "{0:d2}" -f $homePlayer2Rr.stat.strikeOuts
        ($homePlayer2Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $homeVsS2.stat.atBats + ', AVG ' + $homeVsS2.stat.avg + ', HR ' + "{0:d2}" -f $homeVsS2.stat.homeRuns +
                                        ', SLG ' + $homeVsS2.stat.slg + ', OBP ' + $homeVsS2.stat.obp + ', K ' + "{0:d2}" -f $homeVsS2.stat.strikeOuts
        $homePlayer3N.ToUpper()       = 'AB ' + $homePlayer3St.atBats + ', AVG ' + $homePlayer3St.avg + ', HR ' + "{0:d2}" -f $homePlayer3St.homeRuns +
                                        ', SLG ' + $homePlayer3St.slg + ', OBP ' + $homePlayer3St.obp 
        ($homePlayer3Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer3rr.stat.atBats + ', AVG ' + $homePlayer3Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer3Rr.stat.homeRuns +
                                        ', SLG ' + $homePlayer3Rr.stat.slg + ', OBP ' + $homePlayer3Rr.stat.obp + ', K ' + "{0:d2}" -f $homePlayer3Rr.stat.strikeOuts
        ($homePlayer3Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $homeVsS3.stat.atBats + ', AVG ' + $homeVsS3.stat.avg + ', HR ' + "{0:d2}" -f $homeVsS3.stat.homeRuns +
                                        ', SLG ' + $homeVsS3.stat.slg + ', OBP ' + $homeVsS3.stat.obp + ', K ' + "{0:d2}" -f $homeVsS3.stat.strikeOuts
        $homePlayer4N.ToUpper()       = 'AB ' + $homePlayer4St.atBats + ', AVG ' + $homePlayer4St.avg + ', HR ' + "{0:d2}" -f $homePlayer4St.homeRuns +
                                        ', SLG ' + $homePlayer4St.slg + ', OBP ' + $homePlayer4St.obp  
        ($homePlayer4Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer4rr.stat.atBats + ', AVG ' + $homePlayer4Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer4Rr.stat.homeRuns +
                                        ', SLG ' + $homePlayer4Rr.stat.slg + ', OBP ' + $homePlayer4Rr.stat.obp + ', K ' + "{0:d2}" -f $homePlayer4Rr.stat.strikeOuts
        ($homePlayer4Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $homeVsS4.stat.atBats + ', AVG ' + $homeVsS4.stat.avg + ', HR ' + "{0:d2}" -f $homeVsS4.stat.homeRuns +
                                        ', SLG ' + $homeVsS4.stat.slg + ', OBP ' + $homeVsS4.stat.obp + ', K ' + "{0:d2}" -f $homeVsS4.stat.strikeOuts
        $homePlayer5N.ToUpper()       = 'AB ' + $homePlayer5St.atBats + ', AVG ' + $homePlayer5St.avg + ', HR ' + "{0:d2}" -f $homePlayer5St.homeRuns +
                                        ', SLG ' + $homePlayer5St.slg + ', OBP ' + $homePlayer5St.obp 
        ($homePlayer5Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer5rr.stat.atBats + ', AVG ' + $homePlayer5Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer5Rr.stat.homeRuns +
                                        ', SLG ' + $homePlayer5Rr.stat.slg + ', OBP ' + $homePlayer5Rr.stat.obp + ', K ' + "{0:d2}" -f $homePlayer5Rr.stat.strikeOuts
        ($homePlayer5Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $homeVsS5.stat.atBats + ', AVG ' + $homeVsS5.stat.avg + ', HR ' + "{0:d2}" -f $homeVsS5.stat.homeRuns +
                                        ', SLG ' + $homeVsS5.stat.slg + ', OBP ' + $homeVsS5.stat.obp + ', K ' + "{0:d2}" -f $homeVsS5.stat.strikeOuts
        $homePlayer6N.ToUpper()       = 'AB ' + $homePlayer6St.atBats + ', AVG ' + $homePlayer6St.avg + ', HR ' + "{0:d2}" -f $homePlayer6St.homeRuns +
                                        ', SLG ' + $homePlayer6St.slg + ', OBP ' + $homePlayer6St.obp 
        ($homePlayer6Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer6rr.stat.atBats + ', AVG ' + $homePlayer6Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer6Rr.stat.homeRuns +
                                        ', SLG ' + $homePlayer6Rr.stat.slg + ', OBP ' + $homePlayer6Rr.stat.obp + ', K ' + "{0:d2}" -f $homePlayer6Rr.stat.strikeOuts
        ($homePlayer6Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $homeVsS6.stat.atBats + ', AVG ' + $homeVsS6.stat.avg + ', HR ' + "{0:d2}" -f $homeVsS6.stat.homeRuns +
                                        ', SLG ' + $homeVsS6.stat.slg + ', OBP ' + $homeVsS6.stat.obp + ', K ' + "{0:d2}" -f $homeVsS6.stat.strikeOuts
        $homePlayer7N.ToUpper()       = 'AB ' + $homePlayer7St.atBats + ', AVG ' + $homePlayer7St.avg + ', HR ' + "{0:d2}" -f $homePlayer7St.homeRuns +
                                        ', SLG ' + $homePlayer7St.slg + ', OBP ' + $homePlayer7St.obp 
        ($homePlayer7Ns + ' LAST 10') = 'AB ' + "{0:d3}" -f $homePlayer7rr.stat.atBats + ', AVG ' + $homePlayer7Rr.stat.avg + ', HR ' + "{0:d2}" -f $homePlayer7Rr.stat.homeRuns +
                                        ', SLG ' + $homePlayer7Rr.stat.slg + ', OBP ' + $homePlayer7Rr.stat.obp + ', K ' + "{0:d2}" -f $homePlayer7Rr.stat.strikeOuts
        ($homePlayer7Ns + ' VS SP')   = 'AB ' + "{0:d3}" -f $homeVsS7.stat.atBats + ', AVG ' + $homeVsS7.stat.avg + ', HR ' + "{0:d2}" -f $homeVsS7.stat.homeRuns +
                                        ', SLG ' + $homeVsS7.stat.slg + ', OBP ' + $homeVsS7.stat.obp + ', K ' + "{0:d2}" -f $homeVsS7.stat.strikeOuts
        'Last 5 Scores' = 
                           ($homeTeamRecAwayTm[4].Substring(0,3)).toUpper() + ' ' + $homeTeamRecAwayR[4] + ' @ ' + ($homeTeamRecHomeTm[4].Substring(0,3)).toUpper() + ' ' + $homeTeamRecHomeR[4] + ', ' +
                           ($homeTeamRecAwayTm[3].Substring(0,3)).toUpper() + ' ' + $homeTeamRecAwayR[3] + ' @ ' + ($homeTeamRecHomeTm[3].Substring(0,3)).toUpper() + ' ' + $homeTeamRecHomeR[3] + ', ' +
                           ($homeTeamRecAwayTm[2].Substring(0,3)).toUpper() + ' ' + $homeTeamRecAwayR[2] + ' @ ' + ($homeTeamRecHomeTm[2].Substring(0,3)).toUpper() + ' ' + $homeTeamRecHomeR[2] + ', ' +
                           ($homeTeamRecAwayTm[1].Substring(0,3)).toUpper() + ' ' + $homeTeamRecAwayR[1] + ' @ ' + ($homeTeamRecHomeTm[1].Substring(0,3)).toUpper() + ' ' + $homeTeamRecHomeR[1]  

    }
    
    #appends betting info to $matchupStatss object
    foreach($oneR in $oddsApi){
        $thirdDate = Get-Date -Format "d" $oneR.commence_time
        if(($thirdDate -eq $secondDate) -and ($oneR.away_team -like "*$awayTeam*")){
            $outcomes = $oneR.bookmakers.markets.outcomes[0,1] | Where-Object price -LE -105 
            $matchupStatss.MONEYLINE = $outcomes.name + ' ' + $outcomes.price
            #$matchupStatss.'OVER/UNDER' = $outcomes[3] | Select-Object -ExpandProperty point
        }
    }   
    
    if ($homeVsS1 -eq $null){
        $homeTeamStatss.psobject.Properties.Remove(($homePlayer1Ns + ' VS SP'))
    }
    if ($homeVsS2 -eq $null){
        $homeTeamStatss.psobject.Properties.Remove(($homePlayer2Ns + ' VS SP'))
    }
    if ($homeVsS3 -eq $null){
        $homeTeamStatss.psobject.Properties.Remove(($homePlayer3Ns + ' VS SP'))
    }
    if ($homeVsS4 -eq $null){
        $homeTeamStatss.psobject.Properties.Remove(($homePlayer4Ns + ' VS SP'))
    }
    if ($homeVsS5 -eq $null){
        $homeTeamStatss.psobject.Properties.Remove(($homePlayer5Ns + ' VS SP'))
    }
    if ($homeVsS6 -eq $null){
        $homeTeamStatss.psobject.Properties.Remove(($homePlayer6Ns + ' VS SP'))
    }
    if ($homeVsS7 -eq $null){
        $homeTeamStatss.psobject.Properties.Remove(($homePlayer7Ns + ' VS SP'))
    }
    if ($awayVsS1 -eq $null){
        $awayTeamStatss.psobject.Properties.Remove(($awayPlayer1Ns + ' VS SP'))
    }
    if ($awayVsS2 -eq $null){
        $awayTeamStatss.psobject.Properties.Remove(($awayPlayer2Ns + ' VS SP'))
    }
    if ($awayVsS3 -eq $null){
        $awayTeamStatss.psobject.Properties.Remove(($awayPlayer3Ns + ' VS SP'))
    }
    if ($awayVsS4 -eq $null){
        $awayTeamStatss.psobject.Properties.Remove(($awayPlayer4Ns + ' VS SP'))
    }
    if ($awayVsS5 -eq $null){
        $awayTeamStatss.psobject.Properties.Remove(($awayPlayer5Ns + ' VS SP'))
    }
    if ($awayVsS6 -eq $null){
        $awayTeamStatss.psobject.Properties.Remove(($awayPlayer6Ns + ' VS SP'))
    }
    if ($awayVsS7 -eq $null){
        $awayTeamStatss.psobject.Properties.Remove(($awayPlayer7Ns + ' VS SP'))
    }
    
    $matchupStatss | Format-List
    $awayPitcher | Format-List
    $homePitcher | Format-List
    $awayTeamStatss | Format-List
    $homeTeamStatss | Format-List

    Write-Host "Loading Next Matchup..." -ForegroundColor Green

}


