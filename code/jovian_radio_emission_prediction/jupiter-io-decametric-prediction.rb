####################################################################################################
# Description: Script to calculate likely observation windows for Jovian emissions in the Decametric 
# band (10 - 100 Meters).
# Based on the QBasic program: http://www.spaceacademy.net.au/spacelab/projects/jovrad/jovrad.htm 
# 
# Author: David Kirwan https://github.com/davidkirwan/software_defined_radio_telescope
####################################################################################################

require "date"


def compute(th, d0, kr)
  d = d0 + th / 24
  v = (157.0456 + 0.0011159 * d) % 360
  m = (357.2148 + 0.9856003 * d) % 360
  n = (94.3455 + 0.0830853 * d + 0.33 * Math.sin(kr * v)) % 360
  j = (351.4266 + 0.9025179 * d - 0.33 * Math.sin(kr * v)) % 360
  a = 1.916 * Math.sin(kr * m) + 0.02 * Math.sin(kr * 2 * m)
  b = 5.552 * Math.sin(kr * n) + 0.167 * Math.sin(kr * 2 * n)
  k = j + a - b
  r = 1.00014 - 0.01672 * Math.cos(kr * m) - 0.00014 * Math.cos(kr * 2 * m)
  re = 5.20867 - 0.25192 * Math.cos(kr * n) - 0.0061 * Math.cos(kr * 2 * n)
  dt = Math.sqrt(re * re + r * r - 2 * re * r * Math.cos(kr * k))
  sp = r * Math.sin(kr * k) / dt
  ps = sp / 0.017452
  dl = d - dt / 173
  pb = ps - b
  xi = 150.4529 * dl.to_i + 870.4529 * (dl - dl.to_i)
  l3 = (274.319 + pb + xi + 0.01016 * 51) % 360
  u1 = 101.5265 + 203.405863 * dl + pb
  u2 = 67.81114 + 101.291632 * dl + pb
  z = (2 * (u1 - u2)) % 360
  u1 = u1 + 0.472 * Math.sin(kr * z)
  u1 = (u1 + 180) % 360
  
  return u1, l3, dt
end


def outdat(th, ty, tx, u1, l3, dt, s, months)
  da = 0
  dy = (th / 24).to_i + 1
  h = th - (dy - 1) * 24
  
  
  if dy > ty
    m = ((dy - tx) / 30.6).to_i + 3
    da = dy - ty - ((m - 3) * 30.6 + 0.5).to_i
  else
    m = ((dy - 1) / 31).to_i + 1
    da = dy - (m - 1) * 31
  end 
  
  mn = months[m-1]
  
  #PRINT #1, USING f$; dy; mn$; da; h; U1; L3; dt; s$
  return "#{dy}\t#{mn} #{da}\t#{h}\t#{u1.round(2)}\t  #{l3.round(2)}  \t#{dt.round(2)}\t\t#{s}"
end


###################################################################################################

target_year = 2014

puts <<-WELCOME
###################################################################
    JOVIAN IO-DECAMETRIC EMISSION PREDICTIONS FOR #{target_year}
###################################################################
Day\tDate\tHr(UT)\tIo_Phase  CML\t\tDist(AU)\tSource
WELCOME

months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]

pi = Math::PI
kr = pi / 180

e = ((target_year - 1) / 100)
f = 2 - e + (e / 4)
jd = (365.25 * (target_year - 1)).to_i + 1721423 + f + 0.5
d0 = jd - 2435108
incr = 0

if Date.leap?(target_year)
  incr = 1
end

ty = 59 + incr
dmax = 365 + incr
tx = ty + 0.5
th = 0

while (th / 24).to_i + 1 <= dmax
  u1, l3, dt = compute(th, d0, kr)
  s = ""
  if l3 < 255 and l3 > 200 and u1 < 250 and u1 > 220 then s = "Io-A"; end
  if l3 < 180 and l3 > 105 and u1 < 100 and u1 > 80 then s = "Io-B"; end
  if l3 < 350 and l3 > 300 and u1 < 250 and u1 > 230 then s = "Io-C"; end
  
  result = outdat(th, ty, tx, u1, l3, dt, s, months)
  unless s == "" then puts result; end
  
  th += 0.5
end

