# yKicks Contracts

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/johnnyonline/yKicks-contracts.git
   cd yKicks-contracts
   ```

2. **Set up virtual environment**
   ```bash
   uv venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   # Install all dependencies
   uv sync
   ```

   > Note: This project uses [uv](https://github.com/astral-sh/uv) for faster dependency installation. If you don't have uv installed, you can install it with `pip install uv` or follow the [installation instructions](https://github.com/astral-sh/uv#installation).

4. **Environment setup**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys and configuration
   ```

## Usage

1. **Build**
```shell
forge build
```

2. **Test**
```shell
forge test
```

3. **Deploy**

```shell
forge script script/Deploy.s.sol:Deploy --rpc-url <your_rpc_url>
```


## Code Style

Format vyper code with mamushi:
```bash
# Format .vy code
mamushi .
```

Format solidity code with forge:
```bash
# Format .sol code
forge fmt .
```