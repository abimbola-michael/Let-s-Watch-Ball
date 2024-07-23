import 'dart:convert';

import '../models/live_match.dart';

List<LiveMatch> allLiveMatches = [
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:18'",
      score: "1 - 0",
      homeName: "Bayer Leverkusen",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/4zp5rzghewnq82w.webp",
      awayName: "FC Augsburg",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/vl7oqdehzvnr510.webp",
      id: "bayer-leverkusen-vs-fc-augsburg-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:18'",
      score: "0 - 0",
      homeName: "Borussia Dortmund",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/4zp5rzghe4nq82w.webp",
      awayName: "SV Darmstadt 98",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/z318q66hy39qo9j.webp",
      id: "borussia-dortmund-vs-sv-darmstadt-98-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:19'",
      score: "1 - 2",
      homeName: "TSG Hoffenheim",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/kdj2ryoh3wyq1zp.webp",
      awayName: "Bayern Munich",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/yl5ergphjy2r8k0.webp",
      id: "tsg-hoffenheim-vs-bayern-munich-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:19'",
      score: "0 - 0",
      homeName: "Eintracht Frankfurt",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/p3glrw7henvqdyj.webp",
      awayName: "RB Leipzig",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/z318q66hdleqo9j.webp",
      id: "eintracht-frankfurt-vs-rb-leipzig-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:19'",
      score: "1 - 0",
      homeName: "1. FC Heidenheim",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/n54qllh261zqvy9.webp",
      awayName: "FC Köln",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/yl5ergphj74r8k0.webp",
      id: "1-fc-heidenheim-vs-fc-koln-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:17'",
      score: "1 - 0",
      homeName: "Werder Bremen",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/9k82rekhdxorepz.webp",
      awayName: "VfL Bochum",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/kn54qllhy10qvy9.webp",
      id: "werder-bremen-vs-vfl-bochum-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:19'",
      score: "1 - 0",
      homeName: "VfL Wolfsburg",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/56ypq3nhdnkmd7o.webp",
      awayName: "FSV Mainz 05",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/jednm9whl2kryox.webp",
      id: "vfl-wolfsburg-vs-fsv-mainz-05-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:18'",
      score: "0 - 0",
      homeName: "VfB Stuttgart",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/gx7lm7phd7em2wd.webp",
      awayName: "Borussia Monchengladbach",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/l965mkyh9o4r1ge.webp",
      id: "vfb-stuttgart-vs-borussia-monchengladbach-18-05-2024"),
  LiveMatch(
      league: "German National Football Championship",
      date: "18/05/2024",
      time: "08:00 PM",
      status: "H1:18'",
      score: "0 - 0",
      homeName: "Union Berlin",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/9vjxm8gh613r6od.webp",
      awayName: "SC Freiburg",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/l965mkyh924r1ge.webp",
      id: "union-berlin-vs-sc-freiburg-18-05-2024"),
  LiveMatch(
      league: "Vietnam National Football Championship",
      date: "18/05/2024",
      time: "06:45 PM",
      status: "H2:71'",
      score: "1 - 1",
      homeName: "Viettel FC",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/dj2ryohy553q1zp.webp",
      awayName: "Nam Dinh FC",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/4wyrn4h826oq86p.webp",
      id: "viettel-fc-vs-nam-dinh-fc-18-05-2024"),
  LiveMatch(
      league: "2nd place Spain",
      date: "18/05/2024",
      time: "06:30 PM",
      status: "H2:88'",
      score: "0 - 0",
      homeName: "Andorra CF",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/l7oqdeh6463r510.webp",
      awayName: "Burgos CF",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/e4wyrn4hnzjq86p.webp",
      id: "andorra-cf-vs-burgos-cf-18-05-2024"),
  LiveMatch(
      league: "Indonesian National Championship",
      date: "18/05/2024",
      time: "06:30 PM",
      status: "H2:90'",
      score: "3 - 0",
      homeName: "Persib Bandung",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/vjxm8gh4z7xr6od.webp",
      awayName: "Bali United",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/dn1m1ghe757moep.webp",
      id: "persib-bandung-vs-bali-united-18-05-2024"),
  LiveMatch(
      league: "Chinese Premier League",
      date: "18/05/2024",
      time: "06:05 PM",
      status: "Kếtthúc",
      score: "3 - 5",
      homeName: "Qingdao West Coast FC",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/1l4rjnhz7n2m7vx.webp",
      awayName: "Shanghai Port FC",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/8yomo4h7401q0j6.webp",
      id: "qingdao-west-coast-fc-vs-shanghai-port-fc-18-05-2024"),
  LiveMatch(
      league: "English National Football League Division 3",
      date: "18/05/2024",
      time: "09:45 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Bolton Wanderers",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/j1l4rjnhp2vm7vx.webp",
      awayName: "Oxford United",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/vl7oqdehkd8r510.webp",
      id: "bolton-wanderers-vs-oxford-united-18-05-2024"),
  LiveMatch(
      league: "Italian National Championship",
      date: "18/05/2024",
      time: "10:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Lecce",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/kjw2r09hvnwrz84.webp",
      awayName: "Atalanta",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/gx7lm7phyw6m2wd.webp",
      id: "lecce-vs-atalanta-18-05-2024"),
  LiveMatch(
      league: "Turkish National Football Championship",
      date: "18/05/2024",
      time: "10:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Ankaragucu",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/gpxwrxlh826ryk0.webp",
      awayName: "Pendikspor",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/8yomo4h7ynvq0j6.webp",
      id: "ankaragucu-vs-pendikspor-18-05-2024"),
  LiveMatch(
      league: "Turkish National Football Championship",
      date: "18/05/2024",
      time: "10:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Başakşehir Futbol Kulübü",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/gx7lm7phyovm2wd.webp",
      awayName: "Trabzonspor",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/kn54qllhy0dqvy9.webp",
      id: "basaksehir-futbol-kulubu-vs-trabzonspor-18-05-2024"),
  LiveMatch(
      league: "Turkish National Football Championship",
      date: "18/05/2024",
      time: "10:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Besiktas JK",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/gy0or5jhdpgqwzv.webp",
      awayName: "Atakas Hatayspor",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/4wyrn4h8ov0q86p.webp",
      id: "besiktas-jk-vs-atakas-hatayspor-18-05-2024"),
  LiveMatch(
      league: "Turkish National Football Championship",
      date: "18/05/2024",
      time: "10:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Gazisehir Gaziantep",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/p3glrw7h86zqdyj.webp",
      awayName: "Karagumruk",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/jednm9wh134ryox.webp",
      id: "gazisehir-gaziantep-vs-karagumruk-18-05-2024"),
  LiveMatch(
      league: "Turkish National Football Championship",
      date: "18/05/2024",
      time: "10:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Kayserispor",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/jednm9why8jryox.webp",
      awayName: "Konyaspor",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/l965mkyhdlpr1ge.webp",
      id: "kayserispor-vs-konyaspor-18-05-2024"),
  LiveMatch(
      league: "Portuguese National Football Championship",
      date: "19/05/2024",
      time: "11:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Moreirense",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/9dn1m1ghw1jmoep.webp",
      awayName: "Estoril",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/z318q66h548qo9j.webp",
      id: "moreirense-vs-estoril-19-05-2024"),
  LiveMatch(
      league: "Portuguese National Football Championship",
      date: "19/05/2024",
      time: "11:30 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Sporting CP",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/kn54qllhyydqvy9.webp",
      awayName: "GD Chaves",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/yl5ergphx2dr8k0.webp",
      id: "sporting-cp-vs-gd-chaves-19-05-2024"),
  LiveMatch(
      league: "Croatian First Football League",
      date: "19/05/2024",
      time: "11:40 PM",
      status: "UpComing",
      score: "vs",
      homeName: "Slaven Belupo",
      homeLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/z8yomo4hp15q0j6.webp",
      awayName: "Dinamo Zagreb",
      awayLogo:
          "https://90phuttv.ngo/wp-content/uploads/truc-tiep/logos/9dn1m1ghdwwmoep.webp",
      id: "slaven-belupo-vs-dinamo-zagreb-19-05-2024"),
];
