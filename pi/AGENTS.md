# Global Pi Workflow

## Git worktrees

For tasks that modify a Git repository, use an isolated sibling worktree unless the user explicitly asks to work in the current checkout.

- Resolve the repository root with `git rev-parse --show-toplevel`.
- Place the worktree at `<repo-root>.worktrees/<subject>`; for example, `/path/to/repository` uses `/path/to/repository.worktrees/feature-name`.
- Use a concise kebab-case `<subject>` derived from the task. Use the same subject for the branch unless the user specifies another branch name.
- Create it with `git worktree add -b <subject> <repo-root>.worktrees/<subject> HEAD`.
- If the current directory is already a worktree, continue there and do not create a nested worktree.
- Check whether the destination or branch already exists before creating anything; do not remove or overwrite existing worktrees without confirmation.
- After creating a worktree, operate on that worktree explicitly: use absolute paths for file tools and `cd <worktree> && ...` for shell commands. Do not accidentally modify the original checkout.
- Do not move or discard uncommitted changes from the original checkout. Tell the user if those changes need to be transferred.
