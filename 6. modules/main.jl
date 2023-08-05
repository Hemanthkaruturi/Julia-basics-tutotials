# Add current working directory to launch pad
# LOAD_PATH

push!(LOAD_PATH, pwd())

# to import everything
# using BankModule

# to import only required functions
using BankModule: Bank, defaultBank

# to import everything
using CustomerModule

# to import only required functions
import CustomerModule: Customer, defaultCustomer

# using Transactions
# include("Transactions.jl") # or
import Transactions: deposit, withdraw

# This Bank struct is already loaded
bank1 = Bank("First Bank")

# you can access default function using module name
# BankModule.defaultBank(bank1)
defaultBank(bank1) # if specific import

# cust1 = CustomerModule.Customer("Hemanth")
cust1 = Customer("Hemanth") # if specific import

deposit(cust1, bank1, 10.0)

withdraw(cust1, bank1, 30.0)