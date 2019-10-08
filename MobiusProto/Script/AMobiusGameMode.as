class AMobiusGameMode : AGameModeBase
{
    float GlobalMovementSpeed = 3500;

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