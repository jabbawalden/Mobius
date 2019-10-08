class AMobiusGameMode : AGameModeBase
{
    float GlobalMovementSpeed = 4900;

    bool GameStarted = false;

    UPROPERTY()
    TArray<AActor> SpawnedLevels;

    //when array is above 2, delete the first element and remove from array

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        //Print(" " + GlobalMovementSpeed, 5);
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        //Print(" " + GlobalMovementSpeed, 5);
    }
}