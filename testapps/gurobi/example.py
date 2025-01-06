import gurobipy as gp
from gurobipy import GRB

# Create a new model
model = gp.Model("example")

# Create variables
x = model.addVar(name="x")
y = model.addVar(name="y")

# Set objective
model.setObjective(x + y, GRB.MAXIMIZE)

# Add constraints
model.addConstr(x + 2 * y <= 4, "c0")
model.addConstr(4 * x + y >= 1, "c1")
model.addConstr(x - y <= 1, "c2")

# Optimize model
model.optimize()

# Print results
for v in model.getVars():
    print(f"{v.varName} = {v.x}")

print(f"Obj: {model.objVal}")

