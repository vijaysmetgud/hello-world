# Build stage of Docker Image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
# Copy the csproj and restore dependencies first
COPY hello-world.csproj ./   
COPY lib/library.csproj ./lib/  # If applicable
COPY test/unit-tests.csproj ./test/  # If applicable
RUN dotnet restore

# Now copy the rest of the project
COPY . ./

# Build the project
RUN dotnet build -c Release --no-restore
# Copy only the necessary .csproj file into the container

RUN dotnet publish -c Release -o /app/publish --no-build
 
# Final image AS a RUNTIME
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./
ENTRYPOINT ["dotnet", "hello-world.dll"]
