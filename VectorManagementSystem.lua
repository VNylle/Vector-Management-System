local Position = {X = 0, Y = 0} -- Ensure default values
local maxPos = {
  X = {Negative = -100, Positive = 100},
  Y = {Negative = -100, Positive = 100},
}

local mapVectorLocation = {} -- Store vectors
local VectorCoupleGroup = {} -- Store groups

-- huh why this even exist
function endErrorOfPos(axis)
  if axis ~= "X" and axis ~= "Y" then
    print("Axis Is Value Of Err: " .. tostring(axis))
    return
  end
  Position[axis] = 0
end

-- uhh what
function PosOffSet(axis, moral)
  if axis == "X" or axis == "Y" then
    if moral == 0 then
      Position[axis] = maxPos[axis].Negative
    elseif moral == 1 then
      Position[axis] = maxPos[axis].Positive
    else
      print(string.format("Moral Value of Err: %s", tostring(moral)))
    end
  end
end

-- make sure they are reall
if Position.X == nil then endErrorOfPos("X") end
if Position.Y == nil then endErrorOfPos("Y") end

-- let there be vector.
function CreateVectorInfo(name, posX, posY)
  if type(name) ~= "string" then
    print(string.format("Name must be of type string but received %s", tostring(name)))
    return
  end
  mapVectorLocation[name] = {X = posX, Y = posY}
end

-- fuck them vector, group them together
function VectorMakeLove(GroupName, ...)
  if not GroupName then
    print("GroupName is Nil.")
    return
  end

  GroupName = tostring(GroupName) -- Ensure it's a string
  local args = {...}

  if not VectorCoupleGroup[GroupName] then
    VectorCoupleGroup[GroupName] = {}
  end

  for _, memberOfargs in pairs(args) do
    if mapVectorLocation[memberOfargs] then
      VectorCoupleGroup[GroupName][memberOfargs] = mapVectorLocation[memberOfargs]
    end
  end
end

-- I dont think this work? i think it does though
function SubtractVectors(name1, name2, resultName)
  local v1, v2 = mapVectorLocation[name1], mapVectorLocation[name2]
  if not v1 or not v2 then
    print("Error: One or both vectors do not exist.")
    return
  end
  local result = {X = v1.X - v2.X, Y = v1.Y - v2.Y}
  mapVectorLocation[resultName] = result
  print(string.format("Vector %s = %s - %s → X: %d, Y: %d", resultName, name1, name2, result.X, result.Y))
end

-- good naming for you, 10/10
function CanFormTriangle(v1, v2, v3)
  local a, b, c = mapVectorLocation[v1], mapVectorLocation[v2], mapVectorLocation[v3]
  if not a or not b or not c then
    print("Error: One or more vectors do not exist.")
    return false
  end
  local area = math.abs((a.X * (b.Y - c.Y) + b.X * (c.Y - a.Y) + c.X * (a.Y - b.Y)) / 2)
  return area > 0
end

--is this a duplicated function? name so familiar
function TriangleArea(v1, v2, v3)
  if not CanFormTriangle(v1, v2, v3) then
    print("Vectors do not form a valid triangle.")
    return 0
  end
  local a, b, c = mapVectorLocation[v1], mapVectorLocation[v2], mapVectorLocation[v3]
  return math.abs((a.X * (b.Y - c.Y) + b.X * (c.Y - a.Y) + c.X * (a.Y - b.Y)) / 2)
end

-- why the hell this even exist
function IsPointInTriangle(point, v1, v2, v3)
  local p, a, b, c = mapVectorLocation[point], mapVectorLocation[v1], mapVectorLocation[v2], mapVectorLocation[v3]
  if not p or not a or not b or not c then
    print("Error: One or more vectors do not exist.")
    return false
  end

  local fullArea = TriangleArea(v1, v2, v3)
  local area1 = TriangleArea(point, v2, v3)
  local area2 = TriangleArea(v1, point, v3)
  local area3 = TriangleArea(v1, v2, point)

  return math.abs(fullArea - (area1 + area2 + area3)) < 1e-6
end

-- checking if the map exist
function CheckMap()
  for VectorName, Pos in pairs(mapVectorLocation) do
    print(string.format("Vector %s is at X: %d, Y: %d", VectorName, Pos.X, Pos.Y))
  end
end

-- spy on them vector
function CheckCouple()
  for Group, Vectors in pairs(VectorCoupleGroup) do
    for Name, Pos in pairs(Vectors) do
      print(string.format("Group Name: %s, contains Vector %s at X: %d, Y: %d", Group, Name, Pos.X, Pos.Y))
    end
  end
end

-- main or example on how to use it ig? 
CreateVectorInfo("A", 10, 20)
CreateVectorInfo("B", -5, 15)
CreateVectorInfo("C", 7, -8)
CreateVectorInfo("P", 3, 5)

SubtractVectors("A", "B", "AB_Vector") -- A - B = AB_Vector or whatever i didnt think while while writing this

if CanFormTriangle("A", "B", "C") then
  print(string.format("Triangle ABC can form with area: %.2f", TriangleArea("A", "B", "C")))
else
  print("Triangle ABC is not valid.")
end

if IsPointInTriangle("P", "A", "B", "C") then
  print("Point P is inside the triangle ABC.")
else
  print("Point P is outside the triangle ABC.")
end
