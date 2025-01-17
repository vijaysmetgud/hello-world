# Build stage of Docker Image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
COPY *.csproj ./
RUN dotnet restore
COPY . ./
RUN dotnet build -c Release --no-restore
RUN dotnet publish -c Release -o /app/publish --no-build
 
# Final image AS a RUNTIME
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./
ENTRYPOINT ["dotnet", "hello-world.dll"]
