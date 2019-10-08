import AMobiusGameMode;

class AObstacle : AActor 
{
    UPROPERTY()
    AMobiusGameMode GameMode;

    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxCollision;
    default BoxCollision.SetCollisionEnabled(ECollisionEnabled::QueryAndPhysics);
    default BoxCollision.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    UStaticMeshComponent MeshComp;
    default MeshComp.SetCollisionResponseToAllChannels(ECollisionResponse::ECR_Ignore);

    UPROPERTY()
    float MovementSpeed = 3000; //GameMode.GlobalMovementSpeed;

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        GameMode = Cast<AMobiusGameMode>(Gameplay::GetGameMode());
        MovementSpeed = GameMode.GlobalMovementSpeed;
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds)
    {
        MoveLevel(DeltaSeconds);
    }

    UFUNCTION()
    void MoveLevel(float DeltaSeconds)
    {   
        FVector CurrentLoc = GetActorLocation();
        FVector NextLoc = CurrentLoc += FVector(-MovementSpeed * DeltaSeconds, 0, 0);
        // Print("Level Loc is " + NextLoc, 5);
        SetActorLocation(NextLoc);
    }
}