FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy everything
COPY src/ ./src/

# Restore as distinct layers
RUN dotnet restore
# Run unit tests (if the tests fail the build process is stopped)
RUN dotnet test
# Build and publish a release
RUN dotnet publish -r linux-x64 --self-contained true -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app/src
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "hello-world.dll"]
