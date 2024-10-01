from fastapi import APIRouter, HTTPException
from typing import List, Dict, Optional, Annotated

from schema import schemas


from model.accounts import AccountModel


accountRouter = APIRouter(
    tags=["accounts"]
)

accountModel = AccountModel()

# Create a new account
@accountRouter.post("/accounts", response_model=schemas.Account)
async def create_account(account: schemas.Account):
    return await accountModel.createAccount(account)

# Get all accounts
@accountRouter.get("/accounts", response_model=List[schemas.Account])
async def get_all_accounts():
    return await accountModel.getAccounts()

# Get an account by username
@accountRouter.get("/accounts/{username}", response_model=schemas.Account)
async def get_account(username: str):
    return await accountModel.getAccountByUsername(username)

# Update an existing account
@accountRouter.put("/accounts/{username}", response_model=schemas.Account)
async def update_account(username: str, account_update: schemas.AccountUpdate):
    return await accountModel.updateAccount(username, account_update)

# Delete an account by username
@accountRouter.delete("/accounts/{username}", response_model=Dict[str, str])
async def delete_account(username: str):
    return await accountModel.deleteAccount(username)
